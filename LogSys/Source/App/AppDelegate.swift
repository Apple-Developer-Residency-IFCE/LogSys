//
//  AppDelegate.swift
//  LogSys
//
//  Created by Pedro Sousa on 16/09/25.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        LoggerService.shared.setup()
        return true
    }
}
