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
    
    func loadOrCreate() throws(PersistenceError) -> UserPreferenceModel {
        do {
            let descriptor = FetchDescriptor<UserPreferenceModel>()
            if let existing = try context.fetch(descriptor).first { return existing }
            
            let newUserPreference = UserPreferenceModel(preferedGenres: [], createdDate: .now)
            context.insert(newUserPreference)
            try context.save()
            return newUserPreference
        } catch {
            throw .userPreferenceNotFound
        }
    }
    
    func saveGenres(_ genres: [String]) throws(PersistenceError) {
        do {
            let desrciptor = FetchDescriptor<UserPreferenceModel>()
            guard let prefs = try context.fetch(desrciptor).first else { return }
            prefs.preferedGenres = genres
            try context.save()
        } catch {
            throw .saveGenresFailed
        }
    }
}
