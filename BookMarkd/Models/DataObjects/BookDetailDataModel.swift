//
//  BookDetailDataModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 02/02/26.
//

struct BookDetailDataModel: Codable, Identifiable {
    let id: String
    let title: String?
    let description: String?
    let places: [String]?
    let characters: [String]?
    let genre: [String]?
}
