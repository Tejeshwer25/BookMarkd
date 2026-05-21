//
//  SwiftDataBookRepository.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 08/03/26.
//

import Foundation
import SwiftData

final class SwiftDataBookRepository: BookRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func book(id: String) throws(PersistenceError) -> BookModel? {
        let descriptor = FetchDescriptor<BookModel>(
            predicate: #Predicate { $0.id == id }
        )
        
        do {
            return try context.fetch(descriptor).first
        } catch {
            throw .noBookFound
        }
    }
    
    func add(_ book: BookModel) throws(PersistenceError) {
        do {
            context.insert(book)
            try context.save()
        } catch {
            throw .addBookFailed
        }
    }
    
    func remove(id: String) throws(PersistenceError) {
        do {
            let descriptor = FetchDescriptor<BookModel>(
                predicate: #Predicate { $0.id == id }
            )
            guard let book = try context.fetch(descriptor).first else { return }
            context.delete(book)
            try context.save()
        } catch {
            throw .removeBookFailed
        }
    }
    
    func updateReadState(_ state: BookReadingState, for id: String) throws(PersistenceError) {
        do {
            let descriptor = FetchDescriptor<BookModel>(
                predicate: #Predicate { $0.id == id }
            )
            guard let book = try context.fetch(descriptor).first else { return }
            book.readState = state
            if state == .read {
                book.finishedAt = .now
            } else if state == .reading {
                book.startedAt = Date.now
            }
            try context.save()
        } catch {
            throw .updateBookFailed
        }
    }
    
    func updateRating(_ rating: Int, for id: String) throws(PersistenceError) {
        do {
            let descriptor = FetchDescriptor<BookModel>(
                predicate: #Predicate { $0.id == id }
            )
            guard let book = try context.fetch(descriptor).first else { return }
            book.rating = rating
            try context.save()
        } catch {
            throw .updateBookFailed
        }
    }
    
    func addQuote(_ quote: QuotesModel, toBook id: String) throws(PersistenceError) {
        do {
            let descriptor = FetchDescriptor<BookModel>(
                predicate: #Predicate { $0.id == id }
            )
            guard let book = try context.fetch(descriptor).first else { return }
            book.quotes.append(quote)
            context.insert(quote)
            try context.save()
        } catch {
            throw .addQuoteFailed
        }
    }
    
    func deleteQuote(_ quote: QuotesModel, fromBook id: String) throws(PersistenceError) {
        do {
            let descriptor = FetchDescriptor<BookModel>(
                predicate: #Predicate { $0.id == id }
            )
            guard let book = try context.fetch(descriptor).first else { return }
            book.quotes.removeAll { $0.id == quote.id }
            try context.save()
        } catch {
            throw .removeQuoteFailed
        }
    }
    
    func addBookReview(_ review: String, for id: String) throws(PersistenceError) {
        do {
            let descriptor = FetchDescriptor<BookModel>(
                predicate: #Predicate { $0.id == id }
            )
            guard let book = try context.fetch(descriptor).first else { return }
            book.bookReview = review
            try context.save()
        } catch {
            throw .updateBookFailed
        }
    }
}
