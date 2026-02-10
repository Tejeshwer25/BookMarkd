//
//  BookMarkdApp.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 27/12/25.
//

import SwiftUI
import SwiftData

@main
struct BookMarkdApp: App {
    @StateObject var appStore = StorageManageer()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            BookSwiftDataModel.self,
            QuoteSwiftDataModel.self
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(appStore)
    }
}
