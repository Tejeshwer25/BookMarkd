//
//  QuoteSwiftDataModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 09/02/26.
//

import SwiftData
import Foundation

@Model
final class QuoteSwiftDataModel {
    var id: UUID
    var noteType: NoteType
    var text: String
    var pageNumber: Int?
    var date: Date
    
    @Relationship var book: BookSwiftDataModel?
    
    init(id: UUID = UUID(),
         noteType: NoteType,
         text: String,
         pageNumber: Int? = nil,
         date: Date = Date()) {
        
        self.id = id
        self.noteType = noteType
        self.text = text
        self.pageNumber = pageNumber
        self.date = date
    }
}
