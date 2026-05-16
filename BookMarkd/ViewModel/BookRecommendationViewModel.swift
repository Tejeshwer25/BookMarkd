//
//  BookRecommendationViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 29/03/26.
//

import Foundation
import Combine

class BookRecommendationViewModel: ObservableObject {
    @Published var recommendedBooks: [RecommendedBooks] = []
    @Published var loadingBooks: Bool = false
    @Published var searchQuery: String = ""
    @Published var errorInfo: AlertInfoModel = .init(title: "", message: "")
    
    func shouldShowNoResultsLabel() -> Bool {
        return self.recommendedBooks.isEmpty
            && !self.loadingBooks
    }
    
    func checkIfBookExistInLibrary(_ book: RecommendedBooks, booksInLibrary: [BookModel]) -> Bool {
        let booksAlreadyInLibrary = booksInLibrary.contains { libraryBook in
            if book.bookTitle.lowercased() == libraryBook.title.lowercased()
                && libraryBook.authorName.contains(where: { $0.lowercased() == book.bookAuthor.lowercased() }) {
                return true
            }
            return false
        }
        
        return !booksAlreadyInLibrary
    }
    
    func generateBookRecommendations(booksInLibrary: [BookModel], preferences: [UserPreferenceModel]) async {
        do {
            let preferredGenres = preferences.first?.preferedGenres ?? []
            
            self.loadingBooks = true
            self.recommendedBooks = try await RecommendationService().generateRecommendations(from: booksInLibrary,
                                                                                              with: preferredGenres)
            self.loadingBooks = false
        } catch {
            print(error.errorDescription)
            self.errorInfo = .init(title: "Error", message: error.errorDescription)
        }
    }
    
    func refreshRecommendedBooks(booksInLibrary: [BookModel]) {
        self.recommendedBooks = self.recommendedBooks.filter { book in
            self.checkIfBookExistInLibrary(book, booksInLibrary: booksInLibrary)
        }
    }
}
