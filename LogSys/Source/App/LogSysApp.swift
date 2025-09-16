//
//  LogSysApp.swift
//  LogSys
//
//  Created by Pedro Sousa on 15/09/25.
//

import SwiftUI

@main
struct LogSysApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            TransactionView(viewModel: .init(networkService: .shared,
                                             storageService: .shared))
        }
    }
}
