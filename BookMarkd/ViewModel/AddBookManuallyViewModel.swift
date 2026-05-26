//
//  AddBookManuallyViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 20/05/26.
//

import PhotosUI
import SwiftData
import Vision
import Foundation
import Combine

@MainActor
class AddBookManuallyViewModel: ObservableObject {
    @Published var bookTitle: String = ""
    @Published var authorName: String = ""
    @Published var tags: [BookGenre] = []
    @Published var bookDescription: String = ""
    @Published var addBookToState: BookReadingState = .wishlist
    @Published var shouldGenerateUsingAI: Bool = false
    @Published var coverImageData: Data? = nil
    @Published var showAddGenresSheet: Bool = false
    @Published var extractedText: String = ""
    @Published var errorOccured: Bool = false
    @Published var errorMessage: String? = nil
    
    private let bookRepository: any BookRepository
    
    init(bookRepository: any BookRepository,
         bookToAdd: BookModel? = nil) {
        self.bookRepository = bookRepository
        
        if let bookToAdd {
            self.bookTitle = bookToAdd.title
            self.authorName = bookToAdd.authorName.first ?? ""
            self.bookDescription = bookToAdd.bookDescription ?? ""
            self.tags = bookToAdd.themes?.compactMap { BookGenre(rawValue: $0) } ?? []
        }
    }
    
    
    /// Method to add book to DB
    /// - Parameter books: books currently in library
    func addBookToDB(books: [BookModel]) async throws {
        guard !self.bookTitle.isEmpty, !self.authorName.isEmpty else {
            self.errorMessage = "Data empty! Book cannot be added"
            self.errorOccured = true
            return
        }
        
        if books.contains(where: { $0.title.lowercased() == self.bookTitle.lowercased() }) {
            self.errorMessage = "Book already exists in library."
            self.errorOccured = true
            return
        }
        
        var newBook = BookModel(id: UUID().uuidString,
                                title: self.bookTitle,
                                authorName: [self.authorName],
                                readState: self.addBookToState,
                                bookDescription: self.bookDescription,
                                coverImageData: self.coverImageData,
                                isManuallyCreated: true,
                                themes: self.tags.map{$0.rawValue})
        
        do {
            if self.shouldGenerateUsingAI {
                let recommendationService = RecommendationService()
                newBook = try await recommendationService.generateBookDescriptionAndGenres(for: newBook)
            }
            
            try self.bookRepository.add(newBook)
        } catch {
            self.errorOccured = true
            if let error = error as? FoundationModelErrors {
                self.errorMessage = error.errorDescription
            } else if let error = error as? PersistenceError {
                self.errorMessage = error.errorDescription
            } else {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
