//
//  Device.swift
//  Battery
//
//  Created by akaneburyo on 2021/02/27.
//

import Foundation
import SwiftUI

struct Device: Identifiable {
    
    let id: String
    var type: DeviceType
    var name: String?
    var batteryLevel: Float
    
    enum DeviceType {
        case Keyboard
        case Trackpad
        case AirPods
        case AirPodsPro
        case AirPodsProLeft
        case AirPodsProRight
        case Other
    }
    
    func symbol() -> String {
        switch self.type {
            case .Keyboard:         return "􀇳"
            case .Trackpad:         return "􀏃"
            case .AirPodsPro:       return ""
            case .AirPodsProLeft:   return "􀲎"
            case .AirPodsProRight:  return "􀲍"
            default:                return ""
        }
    }
    
    static func getType(_ fromProductId: Int) -> DeviceType {
        switch fromProductId {
            case 613: return DeviceType.Trackpad
            case 615: return DeviceType.Keyboard
            default: return DeviceType.Other
        }
    }
}

extension Device: Equatable {
    public static func ==(lhs: Device, rhs: Device) -> Bool {
        return lhs.id == rhs.id
    }
}
