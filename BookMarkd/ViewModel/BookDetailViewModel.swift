//
//  BookDetailViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 14/02/26.
//

import Combine
import SwiftUI

enum QuoteAction {
    case edit, share, delete, add
}

@MainActor
class BookDetailViewModel: ObservableObject {
    @Published var showAddNoteSheet: Bool = false
    @Published var book: BookModel?
    @Published var bookDetails: BookDetailDataModel? = nil
    @Published var isPageLoading: Bool = false
    @Published var showAllTags: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMesssage: String = ""
    @Published var shouldShowAlert: Bool = false
    @Published var noteToEdit: QuotesModel? = nil
    @Published var noteToShare: QuotesModel? = nil
    
    let bookRepository: any BookRepository
    private let bookService: any BookService
    
    init(bookRepository: any BookRepository, bookService: any BookService) {
        self.bookRepository = bookRepository
        self.bookService = bookService
    }
    
    /// Method to get additional book details
    /// - Parameter bookID: book id
    func getBookDetails(_ bookID: String) {
        if book?.isManuallyCreated == true, let book {
            self.bookDetails = BookDetailDataModel(id: book.id,
                                                   title: book.title,
                                                   description: book.bookDescription,
                                                   places: [],
                                                   characters: [],
                                                   genre: book.themes)
            self.isPageLoading = false
            return
        }
        
        Task {
            do {
                let book = try await self.bookService.getBookDetails(bookID)
                self.bookDetails = book
                withAnimation {
                    self.isPageLoading = false
                }
            } catch {
                withAnimation {
                    self.isPageLoading = false
                    self.shouldShowAlert = true
                }
                
                self.alertTitle = "Error"
                if let error = error as? BookMarkdError {
                    self.alertMesssage = error.errorDescription ?? error.localizedDescription
                } else {
                    self.alertMesssage = error.localizedDescription
                }
            }
        }
    }
    
    func performQuoteAction(_ action: QuoteAction, on note: QuotesModel?) {
        switch action {
        case .edit:
            self.noteToEdit = note
        case .share:
            self.noteToShare = note
        case .add:
            self.showAddNoteSheet.toggle()
        case .delete:
            guard let quote = note, let bookID = self.book?.id else {
                self.alertMesssage = "Failed to delete note"
                self.alertTitle = "Error"
                self.shouldShowAlert = true
                return
            }
            do {
                try self.bookRepository.deleteQuote(quote, fromBook: bookID)
            } catch {
                self.alertMesssage = "Failed to delete note"
                self.alertTitle = "Error"
                self.shouldShowAlert = true
                print(error)
            }
        }
    }
    
    func fetchBookDataFromRepo(_ bookID: String) throws -> BookModel? {
        return try bookRepository.book(id: bookID)
    }
    
    func updateBookReadState(bookID: String) throws {
        try self.bookRepository.updateReadState(.reading, for: bookID)
    }
}
