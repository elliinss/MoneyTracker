//
//  MoneyTrackerApp.swift
//  MoneyTracker
//
//  Created by elina on 04.07.2026.
//

import SwiftUI
import Firebase

@main
struct MoneyTrackerApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
