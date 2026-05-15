//
//  AddNoteView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/01/26.
//

import SwiftUI
import Vision

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var quotesModel: QuotesModel
    
    @State private var errorOccurred: Bool = false
    @State private var errorMessage: String = ""
    @State private var showCamera: Bool = false
    @State private var isProcessingCapture: Bool = false
    @State private var processingError: String? = nil
    
    let inEditMode: Bool = false
    let book: BookModel?
    
    let bookRepository: BookRepository
    let router: Router
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text(book?.title ?? "")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(book?.authorName.joined(separator: ", ") ?? "")
                }
                .padding()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.primaryBrand.opacity(0.5))
            
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
                    self.showCamera = true
                } label: {
                    Image(systemName: "camera.fill")
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
                
                Spacer()
                    .frame(maxWidth: .infinity)
                
                TextField("100", text: Binding(
                    get: { String(self.quotesModel.pageNumber ?? 0) },
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
        }
        .alert("Error", isPresented: $errorOccurred, actions: {}, message: { Text(errorMessage) })
        .frame(maxWidth: .infinity)
        .navigationTitle("Add Note or Quote")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showCamera) {
            CameraCaptureView(
                onImageCaptured: { image in
                    Task { await handleCapturedImage(image) }
                }
            )
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                self.addNotesToolbar
            }
        }
    }
    
    var addNotesToolbar: some View {
        Button {
            let quote = self.quotesModel.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if quote.isEmpty {
                dismiss()
                return
            }
            
            if !self.inEditMode {
                HapticManager.shared.trigger(.success)
                withAnimation {
                    do {
                        try self.bookRepository.addQuote(self.quotesModel,
                                                         toBook: self.book?.id ?? "")
                    } catch {
                        self.errorOccurred = true
                        
                        guard let err = error as? PersistenceError else {
                            self.errorMessage = error.localizedDescription
                            return
                        }
                        
                        self.errorMessage = err.errrorDescription ?? error.localizedDescription
                    }
                }
            }
            dismiss()
        } label: {
            Text(self.inEditMode ? "Edit" : "Save")
        }
    }
    
    /// <#Description#>
    /// - Parameter image: <#image description#>
    private func handleCapturedImage(_ image: UIImage) async {
        await MainActor.run {
            isProcessingCapture = true
        }
        
        do {
            let cameraManager = CameraManager()
            self.quotesModel.text = try await cameraManager.handleCapturedImage(image)
        }
        catch {
            await MainActor.run {
                processingError = error.localizedDescription
            }
        }
        
        await MainActor.run {
            isProcessingCapture = false
        }
    }
}
