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
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        NavigationStack(path: $router.currentScreen) {
            content()
                .toolbarVisibility(self.shouldHideTabbar(), for: .tabBar)
                .navigationDestination(for: NavigationRoutes.self) { route in
                    switch route {
                    case .authorDetails(let id):
                        BookDetailView(bookId: id)
                    case .bookDetails(let id):
                        BookDetailView(bookId: id)
                    case .searchResults(query: _):
                        SearchView(results: .constant([]))
                    case .bookFinishScreen(id: _):
                        FinishBookView()
                    case .addBookScreen:
                        AddBookView()
                    case .bookWishlistScreen:
                        BookWishlistView()
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
