//
//  BookModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/01/26.
//

import Foundation
import SwiftData

@Model
final class BookModel {
    @Attribute(.unique) var id: String
    var title: String
    var authorName: [String]
    var readState: BookReadingState
    var coverImageURL: String?
    var rating: Int?
    var bookDescription: String?
    var themes: [String]?
    
    var createdAt: Date
    var startedAt: Date?
    var finishedAt: Date?
    
    @Relationship(deleteRule: .cascade) var quotes: [QuotesModel]
    
    init(id: String,
         title: String,
         authorName: [String],
         readState: BookReadingState,
         coverImageURL: String? = nil,
         rating: Int? = nil,
         bookDescription: String? = nil,
         themes: [String]? = nil) {
        self.id = id
        self.title = title
        self.authorName = authorName
        self.readState = readState
        self.coverImageURL = coverImageURL
        self.rating = rating
        self.bookDescription = bookDescription
        self.themes = themes
        self.createdAt = Date()
        self.quotes = []
    }
}

enum BookReadingState: String, Codable {
    case wishlist
    case read
    case unread
    case reading
}
