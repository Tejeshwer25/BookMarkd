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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            BookModel.self,
            QuotesModel.self,
            UserPreferenceModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    private var bookRepository: any BookRepository
    private var preferenceRepository: any UserPreferenceRepository
    
    init() {
        let context = sharedModelContainer.mainContext
        bookRepository = SwiftDataBookRepository(context: context)
        preferenceRepository = SwiftDataUserPreferenceRepository(context: context)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                bookRepository: bookRepository,
                preferenceRepository: preferenceRepository
            )
        }
        .modelContainer(sharedModelContainer)
    }
}
