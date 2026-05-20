//
//  FinishBookViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 09/02/26.
//

import Combine
import Foundation

@MainActor
class FinishBookViewModel: ObservableObject {
    @Published private(set) var book: BookModel?
    @Published var errorOccurred: Bool = false
    @Published var errorMessage: String?
    @Published var openAddReviewSheet: Bool = false
    
    var doesBookContainReview: Bool {
        guard let review = self.book?.bookReview, review.isEmpty == false else { return false }
        return true
    }
    
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
    
    func getNumberOfDaysTakenToComplete() -> Int {
        guard let dateStarted = book?.startedAt else { return 0 }
        print(dateStarted)
        
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: dateStarted, to: now)
        print(components)
        
        return components.day ?? 0
    }
    
    func saveBookReview(bookReview: String) {
        if let bookID = self.book?.id {
            do {
                self.book?.bookReview = bookReview
                self.book?.finishedAt = .now
                try bookRepository.addBookReview(bookReview, for: bookID)
            } catch {
                self.handlePersistenceErrors(error)
            }
        }
    }
}
