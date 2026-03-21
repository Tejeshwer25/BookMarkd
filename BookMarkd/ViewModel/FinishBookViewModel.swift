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
    @Published var errorOccurred: Bool = false
    @Published var errorMessage: String?
    
    private let bookRepository: any BookRepository
    
    init(bookRepository: any BookRepository) {
        self.bookRepository = bookRepository
    }
    
    func loadBook(_ id: String) {
        do {
            self.book = try self.bookRepository.book(id: id)
        } catch {
            self.handlePersistenceErrors(error)
        }
    }
    
    func markBookAsRead(bookID: String) {
        do {
            self.book?.readState = .read
            self.book?.finishedAt = .now
            try bookRepository.updateReadState(.read, for: bookID)
        } catch {
            self.handlePersistenceErrors(error)
        }
    }
    
    func updateBookRating(to rating: Int, bookID: String) {
        do {
            self.book?.rating = rating
            try self.bookRepository.updateRating(rating, for: bookID)
        } catch {
            self.handlePersistenceErrors(error)
        }
    }
    
    func handlePersistenceErrors(_ error: Error) {
        self.errorOccurred = true
        
        guard let err = error as? PersistenceError else {
            self.errorMessage = error.localizedDescription
            return
        }
        
        self.errorMessage = err.errrorDescription
    }
}
