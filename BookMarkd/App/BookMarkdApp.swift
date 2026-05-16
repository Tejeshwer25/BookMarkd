//
//  BookMarkdApp.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 27/12/25.
//

import SwiftUI
import SwiftData

enum BookMarkdSchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] {
        [BookModel.self, QuotesModel.self, UserPreferenceModel.self]
    }
}

enum BookMarkdMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [BookMarkdSchemaV1.self]
    }

    static var stages: [MigrationStage] {
        [] // No migrations needed yet
    }
}

@main
struct BookMarkdApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema(versionedSchema: BookMarkdSchemaV1.self)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    private var bookRepository: any BookRepository
    private var preferenceRepository: any UserPreferenceRepository
    private var bookService: any BookService
    
    init() {
        let context = sharedModelContainer.mainContext
        bookRepository = SwiftDataBookRepository(context: context)
        preferenceRepository = SwiftDataUserPreferenceRepository(context: context)
        bookService = BookServiceUtility(apiClient: APIClient())
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                bookRepository: bookRepository,
                preferenceRepository: preferenceRepository,
                bookService: bookService
            )
        }
        .modelContainer(sharedModelContainer)
    }
}
