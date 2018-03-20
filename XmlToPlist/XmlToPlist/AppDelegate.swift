//
//  AppDelegate.swift
//  XmlToPlist
//
//  Created by ouyang wenyuan on 26/02/2018.
//  Copyright © 2018 robotman. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        print("applicationDidFinishLaunching = \(aNotification.name)")
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        print("applicationWillTerminate = \(aNotification.name)")
    }


}

