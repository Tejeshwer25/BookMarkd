//
//  QuotesModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/01/26.
//

import Foundation

struct QuotesModel: Codable {
    var id: UUID
    var noteType: NoteType
    var text: String
    var pageNumber: Int?
    var date: Date
}

enum NoteType: String, Equatable, Codable {
    case quote
    case note
}
