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
                        .font(EditorialSans.bodyMedium)
                }
                
                Button {
                    viewModel.showPhotoPicker = true
                } label: {
                    Label("Import from gallery", systemImage: "photo.fill")
                        .font(EditorialSans.bodyMedium)
                }
            } label: {
                HStack(alignment: .center, spacing: 5) {
                    Image(systemName: "camera.fill")
                    Text("Scan Cover")
                        .font(EditorialSans.button)
                }
                .font(.Editorial.button)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.PRIMARY_BRAND)
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
                                   buttonTextColor: Color.PRIMARY_BRAND,
                                   cornerRadius: 8) {
                self.router.pushScreen(.addBookForm(book: nil))
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
                        await self.handleCapturedImage(uiImage)
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
                Color.SURFACE_LOW.opacity(0.5).ignoresSafeArea()
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
            extractedBook.coverImageURL = url.absoluteString
            
            await MainActor.run {
                self.router.pushScreen(.addBookForm(book: extractedBook))
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
