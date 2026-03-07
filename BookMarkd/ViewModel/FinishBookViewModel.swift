//
//  FinishBookViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 09/02/26.
//

import Combine
import Foundation

class FinishBookViewModel: ObservableObject {
    @Published private(set) var book: BookModel?
    
    private let bookRepository: any BookRepository
    
    init(bookRepository: any BookRepository) {
        self.bookRepository = bookRepository
    }
    
    func loadBook(_ id: String) {
        self.book = self.bookRepository.book(id: id)
    }
    
    func markBookAsRead(bookID: String) {
        self.book?.readState = .read
        self.book?.finishedAt = .now
        try? bookRepository.updateReadState(.read, for: bookID)
    }
    
    func updateBookRating(to rating: Int, bookID: String) {
        self.book?.rating = rating
        try? self.bookRepository.updateRating(rating, for: bookID)
    }
}
