//
//  AddBookViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 22/03/26.
//

import Combine
import Foundation
import SwiftUI

@MainActor
class AddBookViewModel: ObservableObject {
    @Published var bookTitle: String
    @Published var books: [SearchedBooks] = []
    @Published var debouncedTask: Task<Void, Never>? = nil
    @Published var loading: Bool = false
    @Published var booksWishlisted: [String] = []
    @Published var errorOccurred: Bool = false
    @Published var errorMessage: String?
    @Published var viewToShow: ViewsAvailable = .beginSearch
    
    // Add book header properties
    @Published var showPhotoPicker: Bool = false
    @Published var extractedTextFromCover: String = ""
    @Published var showCamera: Bool = false
    @Published var isProcessingCoverCapture: Bool = false
    @Published var coverProcessingError: String = ""
    @Published var showImageCropper: Bool = false
    @Published var pendingCapturedImage: UIImage? = nil
    
    private let bookRepository: any BookRepository
    private let bookService: any BookService
    
    init(bookRepository: BookRepository,
         bookService: BookService,
         bookTitle: String = "") {
        self.bookRepository = bookRepository
        self.bookTitle = bookTitle
        self.bookService = bookService
        
        if bookTitle.isEmpty == false {
            self.searchBook(bookName: self.bookTitle, booksInLibrary: [])
        }
    }
    
    /// Method to add or remove book from wishlist
    /// - Parameter book: Book to be added or removed from wishlist
    func addOrRemoveFromWishlist(_ book: SearchedBooks) {
        let bookModel = BookModel(id: book.id,
                                  title: book.title,
                                  authorName: book.authorName,
                                  readState: book.readState,
                                  coverImageURL: book.coverImageURL)
        
        if self.booksWishlisted.contains(where: { $0 == book.id}) {
            do {
                try self.bookRepository.remove(id: bookModel.id)
                
                withAnimation {
                    self.booksWishlisted.removeAll(where: { $0 == book.id })
                }
            } catch {
                self.errorOccurred = true
                
                guard let err = error as? PersistenceError else {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                self.errorMessage = err.errorDescription
            }
        } else {
            bookModel.readState = .wishlist
            
            do {
                try self.bookRepository.add(bookModel)
                
                withAnimation {
                    self.booksWishlisted.append(book.id)
                }
            } catch {
                self.errorOccurred = true
                
                guard let err = error as? PersistenceError else {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                self.errorMessage = err.errorDescription
            }
        }
    }
    
    /// Method to search book using debounce
    /// - Parameter newValue: bookName
    func searchBook(bookName: String, booksInLibrary: [BookModel]) {
        /// Method to search book using service
        /// - Returns: search results
        func search() async -> [SearchedBooks] {
            do {
                let books = try await self.bookService.searchBooks(bookName)
                return books
            } catch {
                print(error.localizedDescription)
            }
            
            return []
        }
        
        self.debouncedTask?.cancel()
        
        if !bookName.isEmpty {
            self.debouncedTask = Task {
                self.viewToShow = .loading
                self.books = []
                let searchResult = await search()
                
                if Task.isCancelled == false {
                    if !searchResult.isEmpty {
                        self.books = searchResult.filter({ book in
                            let isPresent = booksInLibrary.contains(where: { $0.id == book.id })
                            return !isPresent
                        })
                        self.viewToShow = .searchResults
                    } else {
                        self.viewToShow = .error
                    }
                }
            }
        } else {
            self.viewToShow = .beginSearch
        }
    }
}

// MARK: Add book header section
extension AddBookViewModel {
    func handleCapturedImage(_ image: UIImage) async throws -> (imageURL: URL, extractedBook: BookModel) {
        let cameraManager = CameraManager()
        let fullText = try await cameraManager.handleCapturedImage(image)
        
        let recommendationService = RecommendationService()
        let extractedBook = try await recommendationService.getBookDetailsFromBookCover(for: fullText)
        
        let url = try saveTempImage(image)
        
        return (url, extractedBook)
    }
    
    /// Method to save image in temporary directory
    /// - Parameter image: image to be saved
    /// - Returns: url where image is saved
    func saveTempImage(_ image: UIImage) throws -> URL {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            throw NSError(domain: "AddBookHeaderSection", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to generate JPEG data from image"])
        }
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let fileURL = cachesDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        try data.write(to: fileURL)
        return fileURL
    }
}

extension AddBookViewModel {
    enum ViewsAvailable {
        case beginSearch
        case loading
        case error
        case searchResults
    }
}
