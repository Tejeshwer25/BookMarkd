//
//  NavigationRouter.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 11/01/26.
//

import Foundation
import Combine

enum NavigationRoutes: Hashable {
    case bookDetails(id: UUID)
    case authorDetails(id: UUID)
    case searchResults(query: String)
    case bookFinishScreen(id: UUID)
    case addBookScreen
    case bookWishlistScreen
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
