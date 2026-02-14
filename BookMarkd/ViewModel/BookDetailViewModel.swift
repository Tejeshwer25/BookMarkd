//
//  BookDetailViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 14/02/26.
//

import Combine
import SwiftUI

class BookDetailViewModel: ObservableObject {
    @EnvironmentObject private var store: StorageManageer
    
    @Published var showAddNoteSheet: Bool = false
    @Published var book: BookModel?
    @Published var bookDetails: BookDetailDataModel? = nil
    @Published var isPageLoading: Bool = false
    @Published var showAllTags: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMesssage: String = ""
    @Published var shouldShowAlert: Bool = false
    @Published var noteToEdit: QuotesModel? = nil
    
    /// Method to get additional book details
    /// - Parameter bookID: book id
    func getBookDetails(_ bookID: String) {
        if let url = URL(string: "https://openlibrary.org/") {
            let service = BookServiceUtility(api: .init(baseURL: url))
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
    }
}
