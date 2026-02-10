//
//  BookSwiftDataModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 09/02/26.
//

import SwiftData
import Foundation

@Model
final class BookSwiftDataModel {
    @Attribute(.unique) var id: String
    var title: String
    var bookDescription: String?
    var authorName: [String]
    var coverImageURL: String?
    var readState: BookReadingState
    var rating: Int?
    var themes: [String]?
    
    var createdAt: Date
    var startedAt: Date?
    var finishedAt: Date?
    
    @Relationship(deleteRule: .cascade) var quotes: [QuoteSwiftDataModel]
    
    init(id: String,
             title: String,
             authors: [String],
             readState: BookReadingState,
             coverImageURL: String? = nil,
             rating: Int? = nil,
             bookDescription: String? = nil,
         themes: [String] = []) {
            self.id = id
            self.title = title
            self.authorName = authors
            self.readState = readState
            self.coverImageURL = coverImageURL
            self.rating = rating
            self.bookDescription = bookDescription
            self.themes = themes
            self.createdAt = Date()
            self.quotes = []
        }
}
