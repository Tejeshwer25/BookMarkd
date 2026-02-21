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
    
    static func decodeDataModel(from jsonData: Data) -> OpenLibraryBookDetailsModel? {
        let decoder = JSONDecoder()
        do {
            let book = try decoder.decode(OpenLibraryBookDetailsModel.self, from: jsonData)
            return book
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}


struct FallbackOpenLibraryBookDetailsModel: Codable {
    let title: String
    let description: Description
    let subjectPlaces: [String]
    let subjectPeople: [String]
    let key: String
    let subjects: [String]
    
    // Coding keys to map JSON keys to Swift properties
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case subjectPlaces = "subject_places"
        case subjectPeople = "subject_people"
        case key
        case subjects
    }
    
    static func decodeDataModel(from jsonData: Data) -> FallbackOpenLibraryBookDetailsModel? {
        let decoder = JSONDecoder()
        do {
            let book = try decoder.decode(FallbackOpenLibraryBookDetailsModel.self, from: jsonData)
            return book
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}

// Define the description model
struct Description: Codable {
    let type: String
    let value: String
}
