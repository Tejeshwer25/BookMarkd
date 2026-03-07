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
    
    init(bookRepository: any BookRepository) {
        self.bookRepository = bookRepository
    }
    
    /// Method to get additional book details
    /// - Parameter bookID: book id
    func getBookDetails(_ bookID: String) {
        let service = BookServiceUtility(api: APIClient())
        Task {
            do {
                let book = try await service.getBookDetails(bookID)
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
                self.alertMesssage = error.localizedDescription
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
            ()
        }
    }
}
