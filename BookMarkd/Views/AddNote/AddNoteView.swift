//
//  AddNoteView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/01/26.
//

import SwiftUI
import Vision

struct AddNoteView: View {
    @Bindable var quotesModel: QuotesModel
    @StateObject private var viewModel: AddNoteViewModel
    
    private var inEditMode: AddNotesMode?
    let book: BookModel?
    let router: Router
    
    init(bookRepository: any BookRepository,
         router: Router,
         quotesModel: QuotesModel,
         book: BookModel? = nil,
         inEditMode: AddNotesMode?) {
        self._viewModel = StateObject(wrappedValue: AddNoteViewModel(bookRepository: bookRepository))
        self.router = router
        self.quotesModel = quotesModel
        self.book = book
        self.inEditMode = inEditMode
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if self.inEditMode != nil {
                    HStack {
                        RadioButton(selectedNoteType: $quotesModel.noteType,
                                    noteType: .quote) { noteType in
                            self.quotesModel.noteType = noteType
                        }
                        
                        RadioButton(selectedNoteType: $quotesModel.noteType,
                                    noteType: .reflection) { noteType in
                            self.quotesModel.noteType = noteType
                        }
                        
                        RadioButton(selectedNoteType: $quotesModel.noteType,
                                    noteType: .scene) { noteType in
                            self.quotesModel.noteType = noteType
                        }
                        
                        Spacer()
                        
                        Button {
                            self.viewModel.showCamera = true
                        } label: {
                            Image(systemName: "camera.fill")
                                .accessibilityLabel("Capture note from camera")
                        }
                    }
                    .padding()
                    
                    TextEditor(text: $quotesModel.text)
                        .padding()
                        .overlay {
                            if self.quotesModel.text.isEmpty {
                                VStack {
                                    HStack {
                                        Text("Enter a meaningful quote")
                                            .font(EditorialSans.bodyMedium)
                                        
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .padding(25)
                            }
                        }
                    
                    Spacer(minLength: 25)
                    
                    HStack {
                        Text("Page Number (optional)")
                            .metadataStyle()
                        
                        Spacer()
                            .frame(maxWidth: .infinity)
                        
                        TextField("100", text: Binding(
                            get: {
                                if let pageNumber = self.quotesModel.pageNumber {
                                    return String(pageNumber)
                                } else {
                                    return ""
                                }
                            },
                            set: { newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                if let intVal = Int(filtered) {
                                    self.quotesModel.pageNumber = intVal
                                } else {
                                    self.quotesModel.pageNumber = nil
                                }
                            }
                        ))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .frame(width: 75)
                        .padding(7)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray)
                        }
                    }
                    .padding()
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(quotesModel.text)
                            .font(EditorialSerif.quote)
                        
                        HStack {
                            Spacer()
                            
                            Text("- Hagrid")
                                .font(EditorialSans.caption)
                        }
                    }
                    .padding()
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.SURFACE_LOW)
                    }
                    .frame(maxHeight: .infinity)
                    .padding()
                    .foregroundStyle(Color.ON_SURFACE)
                }
            }
        }
        .navigationTitle(self.inEditMode != nil ? "Currently Annotating" : "\(self.quotesModel.noteType.text) from")
        .navigationSubtitle(self.book?.title ?? "")
        .navigationBarTitleDisplayMode(.large)
        .alert("Error", isPresented: $viewModel.errorOccurred, actions: {}, message: { Text(self.viewModel.errorMessage) })
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $viewModel.showCamera) {
            CameraCaptureView(
                onImageCaptured: { image in
                    Task {
                        self.quotesModel.text = await self.viewModel.handleCapturedImage(image)
                    }
                }
            )
        }
        .toolbar {
            if self.inEditMode != nil {
                ToolbarItem(placement: .confirmationAction) {
                    self.addNotesToolbar
                }
            }
        }
    }
    
    var addNotesToolbar: some View {
        Button {
            let quote = self.quotesModel.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if quote.isEmpty {
                // TODO: Show an alert that empty note cannot be added
                return
            }
            
            if self.inEditMode == .create {
                HapticManager.shared.trigger(.success)
                withAnimation {
                    self.viewModel.addQuoteToBook(quote: quotesModel, book: book)
                }
            }
        } label: {
            Text(self.inEditMode == .edit ? "Edit" : "Save")
        }
    }
}
