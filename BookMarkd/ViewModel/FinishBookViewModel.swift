//
//  FinishBookViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 09/02/26.
//

import Combine

class FinishBookViewModel: ObservableObject {
    @Published var book: BookModel?
    
    func getBook(with id: String, from store: StorageManageer) {
        self.book = store.getBookWith(id: id)
    }
    
    func markBookAsRead(bookID: String, _ store: StorageManageer) {
        self.book?.readState = .read
        store.updateBookReadState(to: .read, for: bookID)
    }
    
    func updateBookRating(to rating: Int, bookID: String, _ store: StorageManageer) {
        self.book?.rating = rating
        store.updateBookRating(to: rating, for: bookID)
    }
}
