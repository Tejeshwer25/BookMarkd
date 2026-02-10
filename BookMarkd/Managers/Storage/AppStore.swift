//
//  StorageManageer.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 01/02/26.
//

import Foundation
import Combine
import SwiftData

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
        if self.bookList.isEmpty {
            self.bookList = self.getBookList()
        }
        if self.bookList.contains(where: { $0.id == book.id }) {
            return
        }
        
        do {
            try self.addBookToSwiftData(self.convertBookToSwiftDataStorageType(book))
            self.bookList.append(book)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Method to add or remove book from wishlist
    /// - Parameter book: book to be added or removed
    func addOrRemoveFromWishlist(book: BookModel) {
        if self.bookList.contains(where: { $0.id == book.id }) {
            do {
                try self.removeBookFromSwiftDataWishlist(book)
                self.bookList.removeAll(where: { $0.id == book.id })
            } catch {
                print(error.localizedDescription)
            }
        } else {
            var newBook = book
            newBook.readState = .wishlist
            do {
                try self.addBookToSwiftData(self.convertBookToSwiftDataStorageType(newBook))
                self.bookList.append(newBook)
            } catch {
                print(error.localizedDescription)
            }
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
                    try self.updateBookModelInSwiftData(self.convertBookToSwiftDataStorageType(book), readState: to)
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
                    try self.addQuoteToBook(self.convertBookToSwiftDataStorageType(book),
                                            quote: self.convertQuoteAppModelToSwiftDataModel(quote))
                    var updatedBook = book
                    updatedBook.quotes?.append(quote)
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
                    try self.updateBookModelInSwiftData(self.convertBookToSwiftDataStorageType(book), rating: rating)
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
    private func removeBookFromSwiftDataWishlist(_ book: BookModel) throws {
        let descriptor = FetchDescriptor<BookSwiftDataModel>(
                predicate: #Predicate { $0.id == book.id }
        )
        
        if let stored = try context.fetch(descriptor).first {
            context.delete(stored)
            try context.save()
        }
    }
    
    /// Method to add book to swift data store
    /// - Parameter book: book to be added
    private func addBookToSwiftData(_ book: BookSwiftDataModel) throws {
        self.context.insert(book)
        try context.save()
    }
    
    /// Method to get book list from swift data
    /// - Returns: book list present in persistent storage
    private func getBookListFromSwiftData() throws -> [BookModel] {
        let descriptor = FetchDescriptor<BookSwiftDataModel>()
        let booksFetched = try context.fetch(descriptor)
        let bookList = booksFetched.map { self.convertSwiftDataBookModelToAppModel($0) }
        return bookList
    }
    
    /// Method to update book data in swift persistent storage
    /// - Parameters:
    ///   - book: book to be updated
    ///   - readState: reading state of book
    ///   - rating: ratings for the book
    private func updateBookModelInSwiftData(_ book: BookSwiftDataModel,
                                            readState: BookReadingState? = nil,
                                            rating: Int? = nil) throws {
        let descriptor = FetchDescriptor<BookSwiftDataModel>(
            predicate: #Predicate { $0.id == book.id }
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
    private func addQuoteToBook(_ book: BookSwiftDataModel, quote: QuoteSwiftDataModel) throws {
        let descriptor = FetchDescriptor<BookSwiftDataModel>(
            predicate: #Predicate { $0.id == book.id }
        )
        
        if let storedBook = try context.fetch(descriptor).first {
            quote.book = storedBook
            storedBook.quotes.append(quote)
            context.insert(quote)
            try context.save()
        }
    }
    
    /// Method to convert app model to swift data model
    /// - Parameter book: app model
    /// - Returns: swift data model
    private func convertBookToSwiftDataStorageType(_ book: BookModel) -> BookSwiftDataModel {
        return BookSwiftDataModel(id: book.id,
                                  title: book.title,
                                  authors: book.authorName,
                                  readState: book.readState,
                                  coverImageURL: book.coverImageURL,
                                  rating: book.rating,
                                  bookDescription: book.description,
                                  themes: book.themes ?? [])
    }
    
    /// Method to convert swift data model to app model
    /// - Parameter book: swift data model
    /// - Returns: app model
    private func convertSwiftDataBookModelToAppModel(_ book: BookSwiftDataModel) -> BookModel {
        return BookModel(id: book.id,
                         title: book.title,
                         authorName: book.authorName,
                         readState: book.readState,
                         coverImageURL: book.coverImageURL,
                         quotes: book.quotes.map { self.convertQuoteSwiftDataModelToAppModel($0) },
                         rating: book.rating,
                         description: book.bookDescription,
                         themes: book.themes)
    }
    
    /// Method to convert Quote app model to swift data model
    /// - Parameter quote: app model
    /// - Returns: swift data model
    private func convertQuoteAppModelToSwiftDataModel(_ quote: QuotesModel) -> QuoteSwiftDataModel {
        return QuoteSwiftDataModel(id: quote.id,
                                   noteType: quote.noteType,
                                   text: quote.text,
                                   pageNumber: quote.pageNumber,
                                   date: quote.date)
    }
    
    /// Method to convert quote swift data model to app model
    /// - Parameter quote: swift data model
    /// - Returns: app model
    private func convertQuoteSwiftDataModelToAppModel(_ quote: QuoteSwiftDataModel) -> QuotesModel {
        return QuotesModel(id: quote.id,
                           noteType: quote.noteType,
                           text: quote.text,
                           pageNumber: quote.pageNumber,
                           date: quote.date)
    }
}
