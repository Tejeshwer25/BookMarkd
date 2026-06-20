//
//  BookListViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 20/06/26.
//

import Combine
import Foundation

@MainActor
class BookListViewModel: ObservableObject {
    private let bookRepository: any BookRepository
    
    @Published var bookList: [BookModel] = []
    @Published var alertInfo: AlertInfoModel = .init(title: "", message: "")
    @Published var bookToDelete: String?
    
    init(bookRepository: any BookRepository, bookList: [BookModel]) {
        self.bookRepository = bookRepository
        self.bookList = bookList
    }
    
    func removeBookConfirmation(book: String) {
        let bookName = bookList.first { $0.id == book }?.title
        self.alertInfo = .init(title: "Remove book from wishlist?",
                               message: "Are you sure you want to remove \(bookName ?? "") from your wishlist?",
                               isVisible: true,
                               actions: [
                                .init(id: .cancel, title: "Cancel", role: .cancel),
                                .init(id: .delete, title: "Delete", role: .destructive)
                               ])
        self.bookToDelete = book
    }
    
    private func removeBookFromWishlist(book: String) {
        let removedBook = self.bookList.first { $0.id == book }
        
        do {
            self.bookList.removeAll { $0.id == book }
            try self.bookRepository.remove(id: book)
        } catch {
            print("Failed to remove book from wishlist")
            if let removedBook {
                self.bookList.append(removedBook)
            }
        }
    }
    
    func handleAlertAction(_ alertAction: AlertAction, bookID: String) {
        switch alertAction {
        case .cancel, .ok:
            self.alertInfo.isVisible = false
        case .delete:
            self.removeBookFromWishlist(book: bookID)
            self.alertInfo.isVisible = false
        }
    }
}
