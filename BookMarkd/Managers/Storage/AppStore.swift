//
//  StorageManageer.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 01/02/26.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

class StorageManageer: ObservableObject {
    @Published private var bookList: [BookModel] = []
    var context: ModelContext!
    
    /// Method to set swift data model context
    /// - Parameter context: model context
    func setContext(_ context: ModelContext) {
        self.context = context
    }
    
    /// Method to get book list from cache if present and if cache is empty it fetched books from persistent storage
    /// - Returns: Book list
    func getBookList() -> [BookModel] {
        if self.bookList.isEmpty {
            do {
                self.bookList = try self.getBookListFromSwiftData()
                return bookList
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return self.bookList
    }
    
    
    /// Method to save book to swift data persistent storage and update cache accordingly
    /// - Parameter book: book model to save
    func addBook(_ book: BookModel) {
        do {
            try self.addBookToSwiftData(book)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Method to remove book from swift data persistent storage
    /// - Parameter book: books to remove from swift data storage
    func removeBook(_ book: BookModel) {
        do {
            try self.removeBookFromSwiftDataWishlist(bookID: book.id)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Method to get book with ID
    /// - Parameter id: book id
    /// - Returns: book
    func getBookWith(id: String) -> BookModel? {
        return self.bookList.first { $0.id == id }
    }
    
    /// Method to updated books reading state
    /// - Parameters:
    ///   - to: updated reading state
    ///   - bookID: book id
    func updateBookReadState(to: BookReadingState, for bookID: String) {
        self.bookList = self.bookList.map { book in
            if book.id == bookID {
                do {
                    try self.updateBookModelInSwiftData(book, readState: to)
                    var updatedBook = book
                    updatedBook.readState = to
                    return updatedBook
                } catch {
                    print(error.localizedDescription)
                }
            }
            return book
        }
        
        print(self.bookList)
    }
    
    /// Method to add quote to book
    /// - Parameters:
    ///   - id: id of book for which quote to be added
    ///   - quote: quote to be added
    func addQuoteToBook(id: String, quote: QuotesModel) {
        self.bookList = self.bookList.map { book in
            if book.id == id {
                do {
                    try self.addQuoteToBook(book,
                                            quote: quote)
                    var updatedBook = book
                    updatedBook.quotes.append(quote)
                    return updatedBook
                } catch {
                    print(error.localizedDescription)
                }
            }
            return book
        }
    }
    
    /// Method to update book rating
    /// - Parameters:
    ///   - rating: new ratings
    ///   - bookId: book id
    func updateBookRating(to rating: Int, for bookId: String) {
        self.bookList = self.bookList.map { book in
            if book.id == bookId {
                do {
                    try self.updateBookModelInSwiftData(book, rating: rating)
                    var updatedBook = book
                    updatedBook.rating = rating
                    return updatedBook
                } catch {
                    print(error.localizedDescription)
                }
            }
            return book
        }
    }
}


// MARK: Swift Data CRUD methods
extension StorageManageer {
    /// Method to remove book from swift data wishlist storage
    /// - Parameter book: Book to be deleted
    private func removeBookFromSwiftDataWishlist(bookID: String) throws {
        let descriptor = FetchDescriptor<BookModel>(
            predicate: #Predicate<BookModel> { $0.id == bookID }
        )

        if let stored = try context.fetch(descriptor).first {
            context.delete(stored)
            try context.save()
        }
    }
    
    /// Method to add book to swift data store
    /// - Parameter book: book to be added
    private func addBookToSwiftData(_ book: BookModel) throws {
        self.context.insert(book)
        try context.save()
    }
    
    /// Method to get book list from swift data
    /// - Returns: book list present in persistent storage
    private func getBookListFromSwiftData() throws -> [BookModel] {
        let descriptor = FetchDescriptor<BookModel>()
        let booksFetched = try context.fetch(descriptor)
        return booksFetched
    }
    
    /// Method to update book data in swift persistent storage
    /// - Parameters:
    ///   - book: book to be updated
    ///   - readState: reading state of book
    ///   - rating: ratings for the book
    private func updateBookModelInSwiftData(_ book: BookModel,
                                            readState: BookReadingState? = nil,
                                            rating: Int? = nil) throws {
        let id = book.id
        let descriptor = FetchDescriptor<BookModel>(
            predicate: #Predicate<BookModel> { $0.id == id }
        )
        
        if let book = try context.fetch(descriptor).first {
            if let readState {
                book.readState = readState
            }
            if let rating {
                book.rating = rating
            }
            try context.save()
        }
    }
    
    /// Method to add quote to a book in swift data storage
    /// - Parameters:
    ///   - book: book to which quote will be added
    ///   - quote: quote to be added
    private func addQuoteToBook(_ book: BookModel, quote: QuotesModel) throws {
        let id = book.id
        let descriptor = FetchDescriptor<BookModel>(
            predicate: #Predicate { $0.id == id }
        )
        
        if let storedBook = try context.fetch(descriptor).first {
            quote.book = storedBook
            storedBook.quotes.append(quote)
            context.insert(quote)
            try context.save()
        }
    }
}
