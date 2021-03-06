//
//  CustomMenu.swift
//  Battery
//
//  Created by 岡橋亮 on 2021/03/06.
//

import Cocoa
import SwiftUI

extension AppDelegate {
    func makeCustomMenu() -> NSMenu {
        let appMenu = NSMenuItem()
        appMenu.submenu = NSMenu()

        let changeFloating = NSMenuItem(
            title: MenuItems.ChangeFloating.rawValue,
            action: #selector(self.changeFloating), keyEquivalent: "r"
        )
        
        changeFloating.state = .on
        
        let reload = NSMenuItem(
            title: MenuItems.Reload.rawValue,
            action: #selector(self.reload), keyEquivalent: "r"
        )
        
        let quit = NSMenuItem(
            title: "Quit \(ProcessInfo.processInfo.processName)",
            action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"
        )

        appMenu.submenu?.addItem(changeFloating)
        appMenu.submenu?.addItem(reload)
        appMenu.submenu?.addItem(NSMenuItem.separator())
        appMenu.submenu?.addItem(quit)

        let mainMenu = NSMenu(title: "Main")
        mainMenu.addItem(appMenu)
        return mainMenu
    }
    
    @objc private func changeFloating() {
        let itemTitle = MenuItems.ChangeFloating.rawValue
        guard let menu = self.application.mainMenu?.item(at: 0),
              let item = menu.submenu?.item(withTitle: itemTitle) else {
            return
        }
        
        if window?.level == .normal {
            window?.level = .floating
            item.state = .on
        } else if window?.level == .floating {
            window?.level = .normal
            item.state = .off
        }
    }
    
    @objc private func reload() {
        NotificationCenter.default.post(name:.reload, object: nil)
    }
}

enum MenuItems:String {
    case Reload
    case ChangeFloating = "Always on Top"
}

extension Notification.Name {
    static let reload = Notification.Name("reload")
}
