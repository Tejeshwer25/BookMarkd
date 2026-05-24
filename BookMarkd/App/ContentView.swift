//
//  ContentView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 27/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var libraryRouter = Router()
    @State private var discoverRouter = Router()
    @State private var insightsRouter = Router()
    @State private var settingsRouter = Router()
    
    let bookRepository: any BookRepository
    let preferenceRepository: any UserPreferenceRepository
    let bookService: any BookService
    
    var body: some View {
        TabView {
            Tab("Library", systemImage: "books.vertical") {
                NavigationStackContainer(
                    router: libraryRouter,
                    bookRepository: bookRepository,
                    bookService: bookService,
                    preferenceRepository: preferenceRepository) {
                        LibraryView(bookRepository: bookRepository)
                }
            }
            
            Tab("Discover", systemImage: "book") {
                NavigationStackContainer(
                    router: discoverRouter,
                    bookRepository: bookRepository,
                    bookService: bookService,
                    preferenceRepository: preferenceRepository) {
                        DiscoverView()
                }
            }
            
            Tab("Insights", systemImage: "chart.xyaxis.line") {
                NavigationStackContainer(
                    router: insightsRouter,
                    bookRepository: bookRepository,
                    bookService: bookService,
                    preferenceRepository: preferenceRepository) {
                        InsightsView()
                }
            }
        }
    }
}

#Preview {
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
    
    ContentView(
        bookRepository: SwiftDataBookRepository(context: sharedModelContainer.mainContext),
        preferenceRepository: SwiftDataUserPreferenceRepository(context: sharedModelContainer.mainContext),
        bookService: BookServiceUtility(apiClient: APIClient())
    )
}
