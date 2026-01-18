//
//  BookModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/01/26.
//

import Foundation

struct BookModel: Codable, Identifiable {
    var id: String
    var title: String
    var authorName: [String]
    var readState: BookReadingState?
    var coverImageURL: String?
    var quotes: [QuotesModel]?
}

enum BookReadingState: String, Equatable, Codable {
    case read
    case unread
    case reading
}
