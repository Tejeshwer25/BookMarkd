//
//  UserPreferenceModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 21/02/26.
//

import Foundation
import SwiftData

@Model
final class UserPreferenceModel {
    var preferedGenres: [String]
    var createdDate: Date
    
    init(preferedGenres: [String], createdDate: Date) {
        self.preferedGenres = preferedGenres
        self.createdDate = createdDate
    }
}
