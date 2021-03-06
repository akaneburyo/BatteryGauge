//
//  BatteryGetter.swift
//  Battery
//
//  Created by akaneburyo on 2021/02/25.
//

import Foundation
import Combine
import IOKit
import IOBluetooth

class BatteryManager: ObservableObject {
    
    @Published var timer : Timer!
    @Published var devices: [Device]
    
    init() {
        self.devices = []
        self.timer = Timer.scheduledTimer(withTimeInterval: 60 * 5, repeats: true) { _ in
            self.updateBatteryLevel()
        }
        self.updateBatteryLevel()
    }
    
    deinit {
        self.timer.invalidate()
    }
    
    public func sync() {
        self.updateBatteryLevel()
    }
    
    private func updateBatteryLevel() {
        self.devices.removeAll()
        self.getLevelFromIOService()
        self.getLevelAndNameFromBLE()
    }
    
    private func getLevelFromIOService(){
        var object : io_object_t
        var iterator = io_iterator_t()
        let port: mach_port_t = kIOMasterPortDefault
        let matchingDict : CFDictionary = IOServiceMatching("AppleDeviceManagementHIDEventService")
        let result = IOServiceGetMatchingServices(port, matchingDict, &iterator)
        
        guard result == KERN_SUCCESS else {
            IOObjectRelease(iterator)
            return
        }
        
        repeat {
            object = IOIteratorNext(iterator)
            guard object != 0 else { continue }
            let percent = IORegistryEntryCreateCFProperty(object, "BatteryPercent" as CFString, kCFAllocatorDefault, 0)
            let address = IORegistryEntryCreateCFProperty(object, "DeviceAddress" as CFString, kCFAllocatorDefault, 0)
            let productId = IORegistryEntryCreateCFProperty(object, "ProductID" as CFString, kCFAllocatorDefault, 0)
            
            if let percent = percent?.takeRetainedValue() as? Int,
               let address = address?.takeRetainedValue() as? String,
               let productId = productId?.takeRetainedValue() as? Int {
                
                if var device = self.devices.first(where: { $0.id == address }) {
                    device.batteryLevel = Float(percent) / 100.0
                    if device.type == .Other {
                        device.type = Device.getType(productId)
                    }
                } else {
                    let device = Device(
                        id: address,
                        type: Device.getType(productId),
                        batteryLevel: Float(percent) / 100.0
                    )
                    self.devices.append(device)
                }
            }
        } while object != 0
        
        IOObjectRelease(object)
        IOObjectRelease(iterator)
    }
    
    
    private func getLevelAndNameFromBLE() {
        guard let devices = IOBluetoothDevice.pairedDevices() else { return }
        
        for item in devices {
            guard let device = item as? IOBluetoothDevice,
                  let address = device.addressString,
                  let name = device.name else { continue }
            
            if !device.isConnected() {
                continue
            }
            
            let batteryCase = device.value(forKey: "batteryPercentCase")
            let batteryLeft = device.value(forKey: "batteryPercentLeft")
            let batteryRight = device.value(forKey: "batteryPercentRight")
            if let batteryCase = batteryCase as? Int,
               let batteryLeft = batteryLeft as? Int,
               let batteryRight = batteryRight as? Int,
               batteryCase + batteryLeft + batteryRight > 0 {
                // AirPods
                
                // Issue: ケースのBattery残量が常に0
//                if var deviceCase = self.devices.first(where: { $0.id == address }) {
//                    deviceCase.batteryLevel = Float(batteryCase) / 100.0
//                } else {
//                    self.devices.append(Device(
//                        id: address,
//                        type: .AirPodsPro,
//                        name: name,
//                        batteryLevel: Float(batteryCase) / 100
//                    ))
//                }
                
                if var deviceLeft = self.devices.first(where: { $0.id == "\(address):L" }) {
                    deviceLeft.batteryLevel = Float(batteryLeft) / 100.0
                } else {
                    self.devices.append(Device(
                        id: "\(address):L",
                        type: .AirPodsProLeft,
                        name: "\(name):L",
                        batteryLevel: Float(batteryLeft) / 100
                    ))
                }
                
                if var deviceRight = self.devices.first(where: { $0.id == "\(address):R" }) {
                    deviceRight.batteryLevel = Float(batteryRight) / 100.0
                } else {
                    self.devices.append(Device(
                        id: "\(address):R",
                        type: .AirPodsProRight,
                        name: "\(name):R",
                        batteryLevel: Float(batteryRight) / 100
                    ))
                }
            } else {
                // Other
                if let index = self.devices.firstIndex(where: { $0.id == address }) {
                    self.devices[index].name = name
                } else {
                    self.devices.append(Device(id: address, type: .Other, name: name, batteryLevel: 0.0))
                }
            }
        }
    }
}
