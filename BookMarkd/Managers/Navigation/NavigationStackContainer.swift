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
                .background(Color.neutral)
                .toolbarVisibility(self.shouldHideTabbar(), for: .tabBar)
                .navigationDestination(for: NavigationRoutes.self) { route in
                    switch route {
                    case .authorDetails(let id):
                        BookDetailView(bookId: id,
                                       bookRepository: bookRepository,
                                       bookService: bookService)
                        .background(Color.neutral)
                    case .bookDetails(let id):
                        BookDetailView(bookId: id,
                                       bookRepository: bookRepository,
                                       bookService: bookService)
                        .navigationTransition(.zoom(sourceID: id, in: namespace))
                        .background(Color.neutral)
                    case .searchResults(query: _):
                        AddBookView(query: .constant(""), bookRepository: bookRepository, bookService: bookService)
                    case .bookFinishScreen(let id):
                        FinishBookView(bookID: id,
                                       bookRepository: bookRepository)
                        .background(Color.neutral)
                    case .addBookScreen:
                        AddBookView(query: .constant(""),
                                    bookRepository: bookRepository, bookService: bookService)
                        .background(Color.neutral)
                    case .bookWishlistScreen:
                        BookWishlistView()
                            .background(Color.neutral)
                    case .genrePreferenceScreen:
                        GenrePreferencesScreen(preferenceRepository: preferenceRepository)
                            .background(Color.neutral)
                    case .addBook(let query):
                        AddBookView(query: .constant(query), bookRepository: bookRepository, bookService: bookService)
                            .background(Color.neutral)
                    case .settings:
                        SettingsView()
                            .background(Color.neutral)
                    case .addBookForm(let image):
                        AddBookManuallyView(bookRepository: bookRepository,
                                            bookImage: image)
                            .background(Color.neutral)
                    case .bookListScreen(let bookList):
                        BookListView(bookList: bookList)
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
