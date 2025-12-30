//
//  MyWineCellarApp.swift
//  MyWineCellar
//
//  Created by Sebastien Lato on 2025-12-29.
//

import SwiftUI
import SwiftData

@main
struct MyWineCellarApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Wine.self,
            Tasting.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppShellView()
        }
        .modelContainer(sharedModelContainer)
    }
}
