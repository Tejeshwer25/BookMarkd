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
    @Published var bookTitle: String = ""
    @Published var errorOccurred: Bool = false
    @Published var errorMessage: String?
    
    let bookRepository: any BookRepository
    
    init(bookRepository: any BookRepository) {
        self.bookRepository = bookRepository
    }
    
    func addBookToStore(book: BookModel) {
        do {
            try self.bookRepository.add(book)
        } catch {
            self.errorOccurred = true
            
            guard let err = error as? PersistenceError else {
                self.errorMessage = error.localizedDescription
                return
            }
            
            self.errorMessage = err.errrorDescription
        }
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
        let wishlistedbooks = self.getWishlishtedBooks(books)
        
        if currentlyReadingBooks.isEmpty && finishedBooks.isEmpty && wishlistedbooks.isEmpty {
            return .noBooksPresent
        } else if currentlyReadingBooks.isEmpty {
            return .noCurrentlyReadingBook
        } else if finishedBooks.isEmpty {
            return .noFinishedBook
        } else {
            return .allBooksPresent
        }
    }
    
    func getFinishedBookDate(book: BookModel) -> String {
        let finishedAt = book.finishedAt ?? Date()
        let month = Calendar.current.component(.month, from: finishedAt)
        let strmonth = DateFormatter().shortMonthSymbols[month - 1]
        let day = Calendar.current.component(.day, from: finishedAt)
        return "\(strmonth) \(day)"
    }
}

extension LibraryViewModel {
    enum LibraryViewType {
        case noBooksPresent, noCurrentlyReadingBook, noFinishedBook, allBooksPresent
    }
}
