//
//  BookRepository.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 07/03/26.
//

import Foundation

protocol BookRepository {
    func book(id: String) throws -> BookModel?
    func add(_ book: BookModel) throws
    func remove(id: String) throws
    func updateReadState(_ state: BookReadingState, for id: String) throws
    func updateRating(_ rating: Int, for id: String) throws
    
    func addQuote(_ quote: QuotesModel, toBook id: String) throws
    func addBookReview(_ review: String, for id: String) throws
    func deleteQuote(_ quote: QuotesModel, fromBook id: String) throws
}
