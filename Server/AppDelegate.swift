//
//  AppDelegate.swift
//  Server
//
//  Created by Tom Singleton on 26/01/2020.
//  Copyright © 2020 Tom Singleton. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        
        let fileManager = FileManager.default
        do {
            let documnetsDir = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let directoryUrl = documnetsDir.appendingPathComponent("files")
            try fileManager.createDirectory(atPath: directoryUrl.path, withIntermediateDirectories: true, attributes: nil)
            
            let fileUrl = directoryUrl.appendingPathComponent("readme.txt")
            if !fileManager.fileExists(atPath: fileUrl.path) {
                try "Put files here for serving".write(toFile: fileUrl.path, atomically: true, encoding: .utf8)
            }
        } catch {
            
        }
        application.isIdleTimerDisabled = true
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

