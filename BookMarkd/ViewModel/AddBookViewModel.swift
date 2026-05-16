//
//  AddBookViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 22/03/26.
//

import Combine
import Foundation
import SwiftUI

@MainActor
class AddBookViewModel: ObservableObject {
    @Published var bookTitle: String
    @Published var books: [SearchedBooks] = []
    @Published var debouncedTask: Task<Void, Never>? = nil
    @Published var loading: Bool = false
    @Published var booksWishlisted: [String] = []
    @Published var errorOccurred: Bool = false
    @Published var errorMessage: String?
    @Published var viewToShow: ViewsAvailable = .beginSearch
    
    let bookRepository: any BookRepository
    let bookService: any BookService
    
    init(bookRepository: BookRepository,
         bookService: BookService,
         bookTitle: String = "") {
        self.bookRepository = bookRepository
        self.bookTitle = bookTitle
        self.bookService = bookService
        
        if bookTitle.isEmpty == false {
            self.searchBook(bookName: self.bookTitle, booksInLibrary: [])
        }
    }
    
    /// Method to add or remove book from wishlist
    /// - Parameter book: Book to be added or removed from wishlist
    func addOrRemoveFromWishlist(_ book: SearchedBooks) {
        let bookModel = BookModel(id: book.id,
                                  title: book.title,
                                  authorName: book.authorName,
                                  readState: book.readState,
                                  coverImageURL: book.coverImageURL)
        
        if self.booksWishlisted.contains(where: { $0 == book.id}) {
            do {
                try self.bookRepository.remove(id: bookModel.id)
                
                withAnimation {
                    self.booksWishlisted.removeAll(where: { $0 == book.id })
                }
            } catch {
                self.errorOccurred = true
                
                guard let err = error as? PersistenceError else {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                self.errorMessage = err.errrorDescription
            }
        } else {
            bookModel.readState = .wishlist
            
            do {
                try self.bookRepository.add(bookModel)
                
                withAnimation {
                    self.booksWishlisted.append(book.id)
                }
            } catch {
                self.errorOccurred = true
                
                guard let err = error as? PersistenceError else {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                self.errorMessage = err.errrorDescription
            }
        }
    }
    
    /// Method to search book using debounce
    /// - Parameter newValue: bookName
    func searchBook(bookName: String, booksInLibrary: [BookModel]) {
        /// Method to search book using service
        /// - Returns: search results
        func search() async -> [SearchedBooks] {
            do {
                let books = try await self.bookService.searchBooks(bookName)
                return books
            } catch {
                print(error.localizedDescription)
            }
            
            return []
        }
        
        self.debouncedTask?.cancel()
        
        if !bookName.isEmpty {
            self.debouncedTask = Task {
                self.viewToShow = .loading
                self.books = []
                let searchResult = await search()
                
                if Task.isCancelled == false {
                    if !searchResult.isEmpty {
                        self.books = searchResult.filter({ book in
                            let isPresent = booksInLibrary.contains(where: { $0.id == book.id })
                            return !isPresent
                        })
                        self.viewToShow = .searchResults
                    } else {
                        self.viewToShow = .error
                    }
                }
            }
        } else {
            self.viewToShow = .beginSearch
        }
    }
}

extension AddBookViewModel {
    enum ViewsAvailable {
        case beginSearch
        case loading
        case error
        case searchResults
    }
}
