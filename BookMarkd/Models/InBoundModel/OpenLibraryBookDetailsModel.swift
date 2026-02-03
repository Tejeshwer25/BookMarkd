//
//  OpenLibraryBookDetailsModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 02/02/26.
//

import Foundation

struct OpenLibraryBookDetailsModel: Codable {
    let title: String?
    let description: String?
    let subjectPlaces: [String]?
    let subjectPeople: [String]?
    let key: String
    let subjects: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case subjectPlaces = "subject_places"
        case subjectPeople = "subject_people"
        case key
        case subjects
    }
}
