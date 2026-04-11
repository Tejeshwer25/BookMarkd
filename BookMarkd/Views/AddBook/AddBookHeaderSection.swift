//
//  AddBookHeaderSection.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 22/03/26.
//

import SwiftUI
import PhotosUI

struct AddBookHeaderSection: View {
    @Binding var bookTitle: String
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var showPhotoPicker: Bool = false
    @State private var extractedText: String = ""
    let router: Router
    
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
    }
}
