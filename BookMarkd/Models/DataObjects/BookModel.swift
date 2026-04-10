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
    var readStateRaw: String
    var readState: BookReadingState {
        get { BookReadingState(rawValue: readStateRaw) ?? .wishlist }
        set { readStateRaw = newValue.rawValue }
    }
    
    var coverImageData: Data?
    var coverImageURL: String?
    var rating: Int?
    var bookDescription: String?
    var themes: [String]?
    var bookReview: String?
    
    var isManuallyCreated: Bool = false
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
         coverImageData: Data? = nil,
         isManuallyCreated: Bool = false,
         themes: [String]? = nil) {
        self.id = id
        self.title = title
        self.authorName = authorName
        self.readStateRaw = readState.rawValue
        self.coverImageURL = coverImageURL
        self.rating = rating
        self.bookDescription = bookDescription
        self.themes = themes
        self.createdAt = Date.now
        self.quotes = []
        self.coverImageData = coverImageData
        self.isManuallyCreated = isManuallyCreated
    }
}

enum BookReadingState: String, Codable, Equatable, CaseIterable {
    case wishlist
    case read
    case unread
    case reading
}
