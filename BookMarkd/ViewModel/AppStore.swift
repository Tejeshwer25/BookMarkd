//
//  AppStore.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 01/02/26.
//

import Foundation
import Combine

class AppStore: ObservableObject {
    @Published private var bookList: [BookModel] = []
    
    func getBookList() -> [BookModel] {
        return self.bookList
    }
    
    func addBook(_ book: BookModel) {
        if self.bookList.contains(where: { $0.id == book.id }) {
            return
        }
        self.bookList.append(book)
    }
    
    func addOrRemoveFromWishlist(book: BookModel) {
        if self.bookList.contains(where: { $0.id == book.id }) {
            self.bookList.removeAll(where: { $0.id == book.id })
        } else {
            var newBook = book
            newBook.readState = .wishlist
            self.bookList.append(newBook)
        }
    }
    
    func getBookWith(id: String) -> BookModel? {
        return self.bookList.first { $0.id == id }
    }
    
    func updateBookReadState(to: BookReadingState, for bookID: String) {
        self.bookList = self.bookList.map { book in
            if book.id == bookID {
                var updatedBook = book
                updatedBook.readState = to
                return updatedBook
            }
            return book
        }
        
        print(self.bookList)
    }
    
    func addQuoteToBook(id: String, quote: QuotesModel) {
        self.bookList = self.bookList.map { book in
            if book.id == id {
                var updatedBook = book
                updatedBook.quotes?.append(.init(id: quote.id,
                                                 noteType: quote.noteType,
                                                 text: quote.text,
                                                 pageNumber: quote.pageNumber,
                                                 date: quote.date))
                return updatedBook
            }
            return book
        }
    }
}
