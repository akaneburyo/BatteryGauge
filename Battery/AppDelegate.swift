//
//  AppDelegate.swift
//  Battery
//
//  Created by akaneburyo on 2021/02/25.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let application = NSApplication.shared
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
                
        application.mainMenu = self.makeCustomMenu()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
            styleMask: [ .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        
        window.isMovableByWindowBackground = true
        window.backgroundColor = NSColor(white: 1, alpha: 0)
        window.level = .floating
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
