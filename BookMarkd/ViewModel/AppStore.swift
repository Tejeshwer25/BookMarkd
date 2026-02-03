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
        print("Added book: \(book.title)")
        if self.bookList.contains(where: { $0.id == book.id }) {
            return
        }
        self.bookList.append(book)
        print("List after adding: \(self.bookList)")
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
}
