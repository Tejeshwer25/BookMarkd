//
//  SearchedBooks.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 19/02/26.
//


import Foundation

class SearchedBooks {
    var id: String
    var title: String
    var authorName: [String]
    var readState: BookReadingState
    var coverImageURL: String?
    var bookDescription: String?
    var themes: [String]?
    
    
    init(id: String,
         title: String,
         authorName: [String],
         readState: BookReadingState,
         coverImageURL: String? = nil,
         bookDescription: String? = nil,
         themes: [String]? = nil) {
        self.id = id
        self.title = title
        self.authorName = authorName
        self.readState = readState
        self.coverImageURL = coverImageURL
        self.bookDescription = bookDescription
        self.themes = themes
    }
}
