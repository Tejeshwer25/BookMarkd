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
    
    init(bookRepository: any BookRepository, preferenceRepository: any UserPreferenceRepository, bookService: any BookService) {
        self.bookRepository = bookRepository
        self.preferenceRepository = preferenceRepository
        self.bookService = bookService
        
        // 1. Create the appearance object
        let appearance = UINavigationBarAppearance()
        
        // 3. Set Custom Font for Large Title
        appearance.largeTitleTextAttributes = [
            .font: UIFont(name: "Newsreader9pt-SemiBold", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .bold),
            .foregroundColor: UIColor(Color.ON_SURFACE)
        ]
        
        // 4. Set Custom Font for Inline (Standard) Title
        appearance.titleTextAttributes = [
            .font: UIFont(name: "Newsreader9pt-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor(Color.ON_SURFACE)
        ]
        
        appearance.subtitleTextAttributes = [
            .font: UIFont(name: "Manrope-Medium", size: 13) ?? UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor(Color.SECONDARY_TEXT)
        ]
        
        // 5. Apply the appearance to all navigation bars
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
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
