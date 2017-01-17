//
//  AppDelegate.swift
//  BB6Status
//
//  Created by Frederic Font Corbera on 23/07/15.
//  Copyright (c) 2015 Frederic Font Corbera. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    let popover = NSPopover()

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "BB6logo")
            button.action = #selector(AppDelegate.togglePopover(_:))
        }
        let radiovc = BBC6MusicViewController(nibName: "ViewController-OSX", bundle: nil)
        popover.contentViewController = radiovc
        radiovc!.setUp()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
}

