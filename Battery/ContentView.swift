//
//  ContentView.swift
//  Battery
//
//  Created by akaneburyo on 2021/02/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var batteryManager = BatteryManager()
    
    private let elementSize:CGFloat = 48
    var body: some View {
        ZStack {
            Color.init(NSColor(white: 1, alpha: 0.8))
                .edgesIgnoringSafeArea(.all)
                .cornerRadius(5.0)
            let devices = self.batteryManager.devices
            Group {
                if devices.isEmpty {
                    BatteryGauge(device: nil)
                        .frame(width: elementSize, height: elementSize, alignment: .center)
                } else {
                    HStack(alignment: .center, spacing: 4, content: {
                        ForEach(devices) { device in
                            BatteryGauge(device: device)
                                .frame(width: elementSize, height: elementSize, alignment: .center)
                        }
                    })
                }
            }
        }
        .padding(.all, 4)
        .padding(.leading, 8)
        .padding(.trailing, 8)
        .onReceive(NotificationCenter.default.publisher(for: .reload)) { _ in
            self.batteryManager.sync()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
