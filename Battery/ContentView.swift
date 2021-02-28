//
//  ContentView.swift
//  Battery
//
//  Created by akaneburyo on 2021/02/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var batteryManager = BatteryManager()
    
    let sync = #selector(AppDelegate.syncAction(_:))
    
    var body: some View {
        ZStack {
            Color.init(NSColor(white: 1, alpha: 0.8))
                .edgesIgnoringSafeArea(.all)
                .cornerRadius(5.0)
            
            HStack(alignment: .center, spacing: 4, content: {
                ForEach(self.batteryManager.devices) { device in
                    BatteryGauge(device: device)
                        .frame(width: 48, height: 48, alignment: .center)
                }
            }       )
            .padding(.all, 4)
            .padding(.leading, 8)
            .padding(.trailing, 8)
        }.onCommand(sync, perform: {
            self.batteryManager.sync()
        })
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
