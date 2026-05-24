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
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @ObservedObject var viewModel: AddBookViewModel
    let router: Router
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            TextField("Search for your next adventure", text: $viewModel.bookTitle)
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
                    viewModel.showCamera = true
                }) {
                    Label("Capture Image", systemImage: "camera.fill")
                }
                
                Button {
                    viewModel.showPhotoPicker = true
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
                self.router.pushScreen(.addBookForm(imageURL: nil))
            }
        }
        .frame(maxWidth: .infinity)
        .photosPicker(isPresented: $viewModel.showPhotoPicker,
                      selection: $selectedPhotoItem)
        .onChange(of: selectedPhotoItem) { oldValue, newValue in
            guard let newValue else { return }
            Task { @MainActor in
                do {
                    if let data = try await newValue.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        let url = try viewModel.saveTempImage(uiImage)
                        self.router.pushScreen(.addBookForm(imageURL: url))
                    }
                } catch {
                    viewModel.coverProcessingError = error.localizedDescription
                }
            }
        }
        .sheet(isPresented: $viewModel.showCamera) {
            CameraCaptureView(
                onImageCaptured: { image in
                    Task { await handleCapturedImage(image) }
                }
            )
        }
        .fullScreenCover(isPresented: $viewModel.isProcessingCoverCapture) {
            ZStack {
                Color.black.opacity(0.5).ignoresSafeArea()
                ProgressView("Analyzing cover…")
            }
        }
        .alert("Error", isPresented: .constant(viewModel.coverProcessingError.isEmpty == false)) {
            Button("OK") {
                viewModel.coverProcessingError = ""
            }
        } message: {
            Text(viewModel.coverProcessingError)
        }
    }
    
    private func handleCapturedImage(_ image: UIImage) async {
        await MainActor.run {
            viewModel.isProcessingCoverCapture = true
        }
        
        do {
            let (url, extractedBook) = try await viewModel.handleCapturedImage(image)
            
            await MainActor.run {
                self.router.pushScreen(.addBookForm(imageURL: url))
                NotificationCenter.default.post(name: Notification.Name("PrefillAddBookFields"), object: nil, userInfo: [
                    "title": extractedBook.title,
                    "author": extractedBook.authorName,
                    "description": extractedBook.bookDescription ?? "",
                    "themes": extractedBook.themes ?? []
                ])
            }
        } catch {
            await MainActor.run {
                if let error = error as? FoundationModelErrors {
                    viewModel.coverProcessingError = error.errorDescription
                } else {
                    viewModel.coverProcessingError = error.localizedDescription
                }
            }
        }
        
        await MainActor.run {
            viewModel.isProcessingCoverCapture = false
        }
    }
}
