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
    
    func book(id: String) -> BookModel? {
        let descriptor = FetchDescriptor<BookModel>(
            predicate: #Predicate { $0.id == id }
        )
        
        return try? context.fetch(descriptor).first
    }
    
    func add(_ book: BookModel) throws {
        context.insert(book)
        try context.save()
    }
    
    func remove(id: String) throws {
        let descriptor = FetchDescriptor<BookModel>(
            predicate: #Predicate { $0.id == id }
        )
        guard let book = try context.fetch(descriptor).first else { return }
        context.delete(book)
        try context.save()
    }
    
    func updateReadState(_ state: BookReadingState, for id: String) throws {
        let descriptor = FetchDescriptor<BookModel>(
            predicate: #Predicate { $0.id == id }
        )
        guard let book = try context.fetch(descriptor).first else { return }
        book.readState = state
        try context.save()
    }
    
    func updateRating(_ rating: Int, for id: String) throws {
        let descriptor = FetchDescriptor<BookModel>(
            predicate: #Predicate { $0.id == id }
        )
        guard let book = try context.fetch(descriptor).first else { return }
        book.rating = rating
        try context.save()
    }
    
    func addQuote(_ quote: QuotesModel, toBook id: String) throws {
        let descriptor = FetchDescriptor<BookModel>(
            predicate: #Predicate { $0.id == id }
        )
        guard let book = try context.fetch(descriptor).first else { return }
        book.quotes.append(quote)
        context.insert(quote)
        try context.save()
    }
}
