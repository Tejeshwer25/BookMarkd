//
//  AddNoteViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 19/05/26.
//

import Combine
import Foundation
import UIKit

@MainActor
class AddNoteViewModel: ObservableObject {
    @Published var errorOccurred: Bool = false
    @Published var errorMessage: String = ""
    @Published var showCamera: Bool = false
    @Published var isProcessingCapture: Bool = false
    @Published var processingError: String? = nil
    
    private let bookRepository: any BookRepository
    
    init(bookRepository: any BookRepository) {
        self.bookRepository = bookRepository
    }
    
    func addQuoteToBook(quote: QuotesModel, book: BookModel?) {
        guard let book else { return }
        
        do {
            try self.bookRepository.addQuote(quote, toBook: book.id)
        } catch {
            self.errorOccurred = true
            
            guard let err = error as? PersistenceError else {
                self.errorMessage = error.localizedDescription
                return
            }
            
            self.errorMessage = err.errorDescription ?? error.localizedDescription
        }
    }
    
    func handleCapturedImage(_ image: UIImage) async -> String {
        self.isProcessingCapture = true
        
        do {
            let cameraManager = CameraManager()
            return try await cameraManager.handleCapturedImage(image)
        }
        catch {
            self.processingError = error.localizedDescription
        }
        
        self.isProcessingCapture = false
        return ""
    }
}
