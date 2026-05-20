//
//  AddNoteViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 19/05/26.
//

import Combine

@MainActor
class AddNoteViewModel: ObservableObject {
    @Published var errorOccurred: Bool = false
    @Published var errorMessage: String = ""
    @Published var showCamera: Bool = false
    @Published var isProcessingCapture: Bool = false
    @Published var processingError: String? = nil
    
    let bookRepository: any BookRepository
    
    init(bookRepository: any BookRepository) {
        self.bookRepository = bookRepository
    }
}
