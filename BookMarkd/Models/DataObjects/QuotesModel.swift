//
//  QuotesModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/01/26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class QuotesModel {
    var id: UUID
    var noteType: NoteType
    var text: String
    var pageNumber: Int?
    var date: Date
    
    @Relationship var book: BookModel?
    
    init(id: UUID,
         noteType: NoteType,
         text: String,
         pageNumber: Int? = nil,
         date: Date) {
        self.id = id
        self.noteType = noteType
        self.text = text
        self.pageNumber = pageNumber
        self.date = date
    }
}

enum NoteType: String, Equatable, Codable {
    case quote
    case reflection
    case scene
    
    var fillColor: Color {
        switch self {
        case .quote: return Color.secondaryBrand
        case .reflection: return Color.tertiaryBrand
        case .scene: return Color.accentColor
        }
    }
    
    var text: String {
        switch self {
        case .quote: return "Quote"
        case .reflection: return "Reflection"
        case .scene: return "Scene"
        }
    }
}
