//
//  LibraryViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 22/01/26.
//

import Foundation
import Combine

class LibraryViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    @Published var showAddBookScreen: Bool = false
    @Published var bookTitle: String = ""
    
    func addBookToStore(store: StorageManageer, book: BookModel) {
        store.addBook(book)
    }
    
    func getBookListFor(readingState state: BookReadingState, from store: StorageManageer) -> [BookModel] {
        switch state {
        case .read:     return self.getFinishedBooks(store)
        case .reading:  return self.getCurrentlyReadingBooks(store)
        case .wishlist: return self.getWishlishtedBooks(store)
        case .unread:   return []
        }
    }
    
    private func getWishlishtedBooks(_ store: StorageManageer) -> [BookModel] {
        return store.getBookList().filter { $0.readState == .wishlist }
    }
    
    private func getFinishedBooks(_ store: StorageManageer) -> [BookModel] {
        return store.getBookList().filter { $0.readState == .read }
    }
    
    private func getCurrentlyReadingBooks(_ store: StorageManageer) -> [BookModel] {
        return store.getBookList().filter { $0.readState == .reading }
    }
    
    func checkForViewToBeShown(_ store: StorageManageer) -> LibraryViewType {
        let currentlyReadingBooks = self.getCurrentlyReadingBooks(store)
        let finishedBooks = self.getFinishedBooks(store)
        
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
