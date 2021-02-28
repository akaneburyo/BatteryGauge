//
//  BatteryGauge.swift
//  Battery
//
//  Created by akaneburyo on 2021/02/25.
//

import SwiftUI

struct BatteryGauge: View {
    @State var device:Device
    
    var body: some View {
        ZStack {
            
            // Stroke color
            let color: Color = {
                if self.device.batteryLevel <= 0.2 {
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
                .trim(from: 0.0, to: CGFloat(self.device.batteryLevel))
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: -90))
                .padding(8)
            
            // Symbol
            Text(self.device.symbol())
                .contextMenu(/*@START_MENU_TOKEN@*/ContextMenu(menuItems: {
                    let percent = Int(self.device.batteryLevel * 100)
                    let batterySymbol:String = {
                        switch percent {
                            case 0..<10: return "􀛪"
                            case 10..<40: return "􀛩"
                            default: return "􀛨"
                        }
                    }()
                    
                    Text(self.device.name ?? "NaN")
                    Text("\(percent)% \(batterySymbol)")
                })
            )
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
