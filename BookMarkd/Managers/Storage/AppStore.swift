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
    func removeBook(_ bookID: String) {
        do {
            try self.removeBookFromSwiftDataWishlist(bookID: bookID)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Method to get book with ID
    /// - Parameter id: book id
    /// - Returns: book
    func getBookWith(id: String) -> BookModel? {
        let descriptor = FetchDescriptor<BookModel>(
            predicate: #Predicate<BookModel> { book in
                book.id == id
            },
            sortBy: []
        )
        
        do {
            let book = try context.fetch(descriptor).first
            return book
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Method to updated books reading state
    /// - Parameters:
    ///   - to: updated reading state
    ///   - bookID: book id
    func updateBookReadState(to: BookReadingState, for bookID: String) {
        let descriptor = FetchDescriptor<BookModel>(
            predicate: #Predicate<BookModel> { $0.id == bookID }
        )
        
        if let book = try? context.fetch(descriptor).first {
            book.readState = to
            try? context.save()
        }
    }
    
    /// Method to add quote to book
    /// - Parameters:
    ///   - id: id of book for which quote to be added
    ///   - quote: quote to be added
    func addQuoteToBook(id: String, quote: QuotesModel) {
        let descriptor = FetchDescriptor<BookModel>(
            predicate: #Predicate<BookModel> { $0.id == id }
        )
        
        do {
            if let storedBook = try context.fetch(descriptor).first {
                quote.book = storedBook
                storedBook.quotes.append(quote)
                context.insert(quote)
                try context.save()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Method to update book rating
    /// - Parameters:
    ///   - rating: new ratings
    ///   - bookId: book id
    func updateBookRating(to rating: Int, for bookId: String) {
        let descriptor = FetchDescriptor<BookModel>(
            predicate: #Predicate<BookModel> { $0.id == bookId }
        )
        
        if let book = try? context.fetch(descriptor).first {
            book.rating = rating
            try? context.save()
        }
    }

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
}
