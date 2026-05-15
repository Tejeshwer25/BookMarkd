//
//  AddBookHeaderSection.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 22/03/26.
//

import SwiftUI
import PhotosUI
import Vision

struct AddBookHeaderSection: View {
    @Binding var bookTitle: String
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var showPhotoPicker: Bool = false
    @State private var extractedText: String = ""
    let router: Router
    
    @State private var showCamera: Bool = false
    @State private var isProcessingCapture: Bool = false
    @State private var processingError: String? = nil
    @State private var showCropper: Bool = false
    @State private var pendingCapturedImage: UIImage? = nil
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            TextField("Search for your next adventure", text: $bookTitle)
                .padding(.horizontal, 10)
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 7)
                .stroke(.gray, lineWidth: 1)
        }
        
        HStack(alignment: .center, spacing: 10) {
            Menu {
                Button(action: {
                    showCamera = true
                }) {
                    Label("Capture Image", systemImage: "camera.fill")
                }
                
                Button {
                    showPhotoPicker = true
                } label: {
                    Label("Import from gallery", systemImage: "photo.fill")
                }
            } label: {
                HStack(alignment: .center, spacing: 5) {
                    Image(systemName: "camera.fill")
                    Text("Scan Cover")
                }
                .font(.Editorial.button)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.accent)
                .padding(.horizontal, 18)
                .padding(.vertical, 18)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.neutralButton)
                }
            }
            
            RoundedRectangleButton(buttonText: "Edit Manually",
                                   imageName: "rectangle.and.pencil.and.ellipsis",
                                   buttonFillColor: Color.neutralButton,
                                   buttonTextColor: Color.accent,
                                   cornerRadius: 8) {
                self.router.pushScreen(.addBookForm(bookImage: nil))
            }
        }
        .frame(maxWidth: .infinity)
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedPhotoItem)
        .onChange(of: selectedPhotoItem) { oldValue, newValue in
            guard let newValue else { return }
            Task { @MainActor in
                if let data = try? await newValue.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    self.router.pushScreen(.addBookForm(bookImage: uiImage))
                }
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraCaptureView(
                onImageCaptured: { image in
                    Task { await handleCapturedImage(image) }
                }
            )
        }
        .fullScreenCover(isPresented: $isProcessingCapture) {
            ZStack {
                Color.black.opacity(0.5).ignoresSafeArea()
                ProgressView("Analyzing cover…")
            }
        }
        .alert("Error", isPresented: .constant(processingError != nil)) {
            Button("OK") {
                processingError = nil
            }
        } message: {
            Text(processingError ?? "")
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
            let fullText = try await cameraManager.handleCapturedImage(image)
            
            let recommendationService = RecommendationService()
            let extractedBook = try await recommendationService.getBookDetailsFromBookCover(for: fullText)
            
            await MainActor.run {
                self.router.pushScreen(.addBookForm(bookImage: image))
                NotificationCenter.default.post(name: Notification.Name("PrefillAddBookFields"), object: nil, userInfo: [
                    "title": extractedBook.title,
                    "author": extractedBook.authorName,
                    "description": extractedBook.bookDescription ?? "",
                    "themes": extractedBook.themes ?? []
                ])
            }
        } catch {
            await MainActor.run {
                processingError = error.localizedDescription
            }
        }
        
        await MainActor.run {
            isProcessingCapture = false
        }
    }
}
