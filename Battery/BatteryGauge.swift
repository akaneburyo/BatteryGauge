//
//  BatteryGauge.swift
//  Battery
//
//  Created by akaneburyo on 2021/02/25.
//

import SwiftUI

struct BatteryGauge: View {
    @State var device:Device?
    
    var body: some View {
        Group {
            if let device = self.device {
                ZStack {
                    // Stroke color
                    let color: Color = {
                        if device.batteryLevel <= 0.2 {
                            return Color.red
                        } else {
                            return Color.green
                        }
                    }()
                    
                    // Background
                    Circle()
                        .stroke(lineWidth: 4)
                        .opacity(0.3)
                        .foregroundColor(Color.gray)
                        .padding(8)
                    
                    // Gauge
                    Circle()
                        .trim(from: 0.0, to: CGFloat(device.batteryLevel))
                        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                        .foregroundColor(color)
                        .rotationEffect(Angle(degrees: -90))
                        .padding(8)
                    
                    // Symbol
                    Text(device.symbol())
                        .contextMenu(/*@START_MENU_TOKEN@*/ContextMenu(menuItems: {
                            if let percent = Int(device.batteryLevel * 100) {
                                let batterySymbol:String = {
                                    switch percent {
                                        case 0..<10: return "􀛪"
                                        case 10..<40: return "􀛩"
                                        default: return "􀛨"
                                    }
                                }()
                                Text(device.name ?? "NaN")
                                Text("\(percent)% \(batterySymbol)")
                            }else {
                                Text("Device not found.")
                            }
                        })
                    )
                }
            } else {
                Text("􀅍")
                    .contextMenu(/*@START_MENU_TOKEN@*/ContextMenu(menuItems: {
                        Text("Device not found.")
                    })
                )
            }
        }
    }
}

struct BatteryGauge_Previews: PreviewProvider {
    static var previews: some View {
        BatteryGauge(device: Device(
            id: "",
            type: .Keyboard,
            name: "test",
            batteryLevel: 0.5
        )).frame(width: 50, height: 50, alignment: .center)
    }
}
