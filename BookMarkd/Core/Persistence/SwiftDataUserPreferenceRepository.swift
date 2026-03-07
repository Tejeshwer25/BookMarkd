//
//  SwiftDataUserPreferenceRepository.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 08/03/26.
//

import Foundation
import SwiftData

final class SwiftDataUserPreferenceRepository: UserPreferenceRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func loadOrCreate() -> UserPreferenceModel {
        let descriptor = FetchDescriptor<UserPreferenceModel>()
        if let existing = try? context.fetch(descriptor).first { return existing }
        
        let newUserPreference = UserPreferenceModel(preferedGenres: [], createdDate: .now)
        context.insert(newUserPreference)
        try? context.save()
        return newUserPreference
    }
    
    func saveGenres(_ genres: [String]) throws {
        let desrciptor = FetchDescriptor<UserPreferenceModel>()
        guard let prefs = try? context.fetch(desrciptor).first else { return }
        prefs.preferedGenres = genres
        try context.save()
    }
}
