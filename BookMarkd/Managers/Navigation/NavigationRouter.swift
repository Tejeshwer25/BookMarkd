//
//  NavigationRouter.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 11/01/26.
//

import Foundation
import Combine
import UIKit

enum NavigationRoutes: Hashable {
    case bookDetails(id: String)
    case authorDetails(id: String)
    case searchResults(query: String)
    case bookFinishScreen(id: String)
    case addBookScreen
    case bookWishlistScreen
    case genrePreferenceScreen
    case addBook(query: String)
    case settings
    case addBookForm(book: BookModel?)
    case bookListScreen(bookList: [BookModel])
}

final class Router: ObservableObject {
    @Published var currentScreen: [NavigationRoutes] = []
    
    func pushScreen(_ screen: NavigationRoutes) {
        self.currentScreen.append(screen)
    }
    
    func popScreen() {
        _ = self.currentScreen.popLast()
    }
    
    func popToRoot() {
        self.currentScreen.removeAll()
    }
}
