//
//  UserPreferenceRepository.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 08/03/26.
//

import Foundation

protocol UserPreferenceRepository {
    func loadOrCreate() throws -> UserPreferenceModel
    func saveGenres(_ genres: [String]) throws
}
