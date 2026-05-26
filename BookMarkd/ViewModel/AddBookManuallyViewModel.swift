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
    @Published var extractedBook: BookModel? = nil
    
    private let bookRepository: any BookRepository
    
    init(bookRepository: any BookRepository,
         coverImage: Data? = nil) {
        self.bookRepository = bookRepository
        self.coverImageData = coverImage
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
    
    /// Method to extract text from imported image
    /// - Parameter image: imported image
    func extractText(from image: UIImage) throws {
        guard let cgImage = image.cgImage else { return }
        
        // Set up the request for text recognition
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                self.errorMessage = "Cover recognition failed: \(error.localizedDescription)"
                self.errorOccured = true
                return
            }
            
            // Process the results from the Vision request
            if let observations = request.results as? [VNRecognizedTextObservation] {
                // Extract the top-most recognized text
                var fullText = ""
                for observation in observations {
                    guard let topCandidate = observation.topCandidates(1).first else { continue }
                    fullText += topCandidate.string + "\n"
                }
                
                Task {
                    do {
                        let extractedBook = try await RecommendationService().getBookDetailsFromBookCover(for: fullText)
                        self.extractedBook = extractedBook
                    } catch {
                        if let error = error as? FoundationModelErrors {
                            self.errorMessage = error.errorDescription
                        } else {
                            self.errorMessage = error.localizedDescription
                        }
                        self.errorOccured = true
                        throw error
                    }
                }
                
            }
        }
        
        // Perform the text recognition
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([request])
        } catch {
            self.errorMessage = "Cover recognition failed: \(error.localizedDescription)"
            self.errorOccured = true
            throw error
        }
    }
}
