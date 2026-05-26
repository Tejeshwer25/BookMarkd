//
//  GenrePreferenceViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 24/05/26
//

import Combine

@MainActor
class GenrePreferenceViewModel: ObservableObject {
    @Published var searchedGenre: String = ""
    @Published var selectedGenres: [BookGenre] = []
    private let preferenceRepository: any UserPreferenceRepository
    
    var genres: [BookGenre] {
        if searchedGenre.isEmpty {
            return BookGenre.allCases
        } else {
            return BookGenre.allCases.filter { $0.rawValue.contains(searchedGenre) }
        }
    }
    
    init(preferenceRepository: any UserPreferenceRepository) {
        self.preferenceRepository = preferenceRepository
    }
    
    func isGenreSelected(genre: BookGenre) -> Bool {
        return selectedGenres.contains(genre)
    }
    
    func toggleGenreSelection(genre: BookGenre) {
        if selectedGenres.contains(genre) {
            selectedGenres.removeAll(where: { $0 == genre })
        } else {
            selectedGenres.append(genre)
        }
    }
    
    func shouldEnableSaveButton() -> Bool {
        // If no genre is selected return false
        if selectedGenres.isEmpty { return false }
        
        let currentlySavedGenres = try? self.preferenceRepository.loadOrCreate().preferedGenres.sorted()
        let selectedGenresSorted = self.selectedGenres.map({ $0.rawValue }).sorted()
        
        // If saved genres matches the currently selected genres return false
        if currentlySavedGenres == selectedGenresSorted {
            return false
        }
        
        return true
    }
    
    func saveGenresToStorage() throws {
        try self.preferenceRepository.saveGenres(self.selectedGenres.map { $0.rawValue })
        HapticManager.shared.trigger(.success)
    }
    
    func loadGenresFromStore() throws {
        let selectedGenres = try self.preferenceRepository.loadOrCreate().preferedGenres.map { BookGenre(rawValue: $0) }
        var genres: [BookGenre] = []
        for genre in selectedGenres {
            if let genre {
                genres.append(genre)
            }
        }
        
        self.selectedGenres = genres
    }
}
