//
//  NavigationStackContainer.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 11/01/26.
//

import SwiftUI
import Combine

struct NavigationStackContainer<Content: View>: View {
    @ObservedObject var router: Router
    let bookRepository: any BookRepository
    let bookService: any BookService
    let preferenceRepository: any UserPreferenceRepository
    @Namespace private var namespace
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        NavigationStack(path: $router.currentScreen) {
            content()
                .frame(maxHeight: .infinity)
                .background(Color.SURFACE)
                .toolbarVisibility(self.shouldHideTabbar(), for: .tabBar)
                .navigationDestination(for: NavigationRoutes.self) { route in
                    switch route {
                    case .bookDetails(let id):
                        BookDetailView(bookId: id,
                                       bookRepository: bookRepository,
                                       bookService: bookService)
                        .navigationTransition(.zoom(sourceID: id, in: namespace))
                        .background(Color.SURFACE)
                    case .searchResults(query: _):
                        AddBookView(query: .constant(""), bookRepository: bookRepository, bookService: bookService)
                    case .bookFinishScreen(let id):
                        FinishBookView(bookID: id,
                                       bookRepository: bookRepository)
                        .background(Color.SURFACE)
                    case .addBookScreen:
                        AddBookView(query: .constant(""),
                                    bookRepository: bookRepository, bookService: bookService)
                        .background(Color.SURFACE)
                    case .genrePreferenceScreen:
                        GenrePreferencesScreen(preferenceRepository: preferenceRepository)
                            .background(Color.SURFACE)
                    case .addBook(let query):
                        AddBookView(query: .constant(query), bookRepository: bookRepository, bookService: bookService)
                            .background(Color.SURFACE)
                    case .settings:
                        SettingsView()
                            .background(Color.SURFACE)
                    case .addBookForm(let book):
                        AddBookManuallyView(bookRepository: bookRepository,
                                            bookToAdd: book)
                        .background(Color.SURFACE)
                    case .bookListScreen(let bookList):
                        BookListView(bookRepository: bookRepository, bookList: bookList)
                            .background(Color.SURFACE)
                    case .addNotes(let quote, let inEditMode, let book):
                        let finalQuote = quote ?? .init(id: .init(),
                                                        noteType: .quote,
                                                        text: "",
                                                        date: .init())
                        AddNoteView(bookRepository: bookRepository,
                                    router: router,
                                    quotesModel: finalQuote,
                                    book: book,
                                    inEditMode: inEditMode)
                            .background(Color.SURFACE)
                            .navigationTransition(.zoom(sourceID: finalQuote.id, in: namespace))
                    }
                }
        }
        .environmentObject(router)
    }
    
    func shouldHideTabbar() -> Visibility {
        let isHidden = !self.router.currentScreen.isEmpty
        
        return isHidden ? .hidden : .visible
    }
}

