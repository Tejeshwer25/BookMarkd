//
//  LibraryViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 22/01/26.
//

import Foundation
import Combine
import _SwiftData_SwiftUI

class LibraryViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    @Published var showAddBookScreen: Bool = false
    @Published var bookTitle: String = ""
    
    func addBookToStore(store: StorageManageer, book: BookModel) {
        store.addBook(book)
    }
    
    func getBookListFor(readingState state: BookReadingState, from books: [BookModel]) -> [BookModel] {
        switch state {
        case .read:     return self.getFinishedBooks(books)
        case .reading:  return self.getCurrentlyReadingBooks(books)
        case .wishlist: return self.getWishlishtedBooks(books)
        case .unread:   return []
        }
    }
    
    private func getWishlishtedBooks(_ books: [BookModel]) -> [BookModel] {
        return books.filter { $0.readState == .wishlist }
    }
    
    private func getFinishedBooks(_ books: [BookModel]) -> [BookModel] {
        return books.filter { $0.readState == .read }
    }
    
    private func getCurrentlyReadingBooks(_ books: [BookModel]) -> [BookModel] {
        return books.filter { $0.readState == .reading }
    }
    
    func checkForViewToBeShown(_ books: [BookModel]) -> LibraryViewType {
        let currentlyReadingBooks = self.getCurrentlyReadingBooks(books)
        let finishedBooks = self.getFinishedBooks(books)
        
        if currentlyReadingBooks.isEmpty && finishedBooks.isEmpty {
            return .noBooksPresent
        } else if currentlyReadingBooks.isEmpty {
            return .noCurrentlyReadingBook
        } else if finishedBooks.isEmpty {
            return .noFinishedBook
        } else {
            return .allBooksPresent
        }
    }
}

extension LibraryViewModel {
    enum LibraryViewType {
        case noBooksPresent, noCurrentlyReadingBook, noFinishedBook, allBooksPresent
    }
}
