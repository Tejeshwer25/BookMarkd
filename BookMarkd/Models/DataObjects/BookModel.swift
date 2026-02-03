//
//  BookModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/01/26.
//

import Foundation

struct BookModel: Codable, Identifiable {
    let id: String
    var title: String
    var authorName: [String]
    var readState: BookReadingState
    var coverImageURL: String?
    var quotes: [QuotesModel]?
    var rating: Int?
    var description: String?
    var themes: [String]?
}

enum BookReadingState: String, Equatable, Codable {
    case wishlist
    case read
    case unread
    case reading
}
