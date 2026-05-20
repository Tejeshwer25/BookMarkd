//
//  AddBookManuallyView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 22/03/26.
//

import SwiftUI
import PhotosUI
import SwiftData
import Vision
import Foundation
import UIKit

@MainActor
struct AddBookManuallyView: View {
    @EnvironmentObject private var router: Router
    @Query private var books: [BookModel]
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var coverImage: Image? = nil
    @StateObject private var viewModel: AddBookManuallyViewModel
    
    init(bookRepository: any BookRepository, bookImageURL: URL? = nil) {
        if let bookImageURL,
           let data = try? Data(contentsOf: bookImageURL),
           let uiImage = UIImage(data: data) {
            self._coverImage = State(initialValue: Image(uiImage: uiImage))
            self._viewModel = StateObject(wrappedValue: AddBookManuallyViewModel(bookRepository: bookRepository,
                                                                                 coverImage: data))
        } else {
            self._coverImage = State(initialValue: nil)
            self._viewModel = StateObject(wrappedValue: AddBookManuallyViewModel(bookRepository: bookRepository,
                                                                                 coverImage: nil))
        }
    }
    
    var body: some View {
        let currentCoverImage = coverImage
        
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    if let coverImage {
                        coverImage
                            .resizable()
                            .frame(width: 168, height: 228)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    } else {
                        PhotosPicker(
                            selection: $selectedPhotoItem,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            if let coverImage = currentCoverImage {
                                coverImage
                                    .resizable()
                                    .frame(width: 168, height: 228)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } else {
                                VStack(alignment: .center) {
                                    Image(systemName: "photo.badge.plus")
                                        .resizable()
                                        .frame(width: 27, height: 24)
                                    Text("ADD COVER")
                                }
                                .padding(.horizontal, 50)
                                .padding(.vertical, 90)
                                .background {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.gray.opacity(0.2))
                                }
                            }
                        }
                        .onChange(of: selectedPhotoItem) { oldValue, newValue in
                            guard let newValue else { return }
                            
                            Task { @MainActor in
                                if let data = try? await newValue.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    self.coverImage = Image(uiImage: uiImage)
                                    self.viewModel.coverImageData = data
                                }
                            }
                        }
                    }
                    
                    TextField("Book Title", text: $viewModel.bookTitle)
                        .font(.Editorial.bookTitle)
                        .padding(.top)
                    
                    TextField("Author Name", text: $viewModel.authorName)
                        .font(.Editorial.sectionTitle)
                        .padding(.top)
                    
                    HStack {
                        Text("Add to State")
                            .font(.Editorial.body)
                            .foregroundStyle(Color.primaryBrand)
                        
                        Spacer()
                        
                        Picker(selection: $viewModel.addBookToState) {
                            Text("Select a value").tag(nil as String?)
                            
                            ForEach(BookReadingState.allCases, id: \.self) { flavor in
                                Text(flavor.rawValue.capitalized).tag(flavor)
                            }
                        } label: {
                            Text(self.viewModel.addBookToState.rawValue.capitalized)
                        }
                        .pickerStyle(.menu)
                    }
                    .padding(.top)
                    
                    HStack {
                        Text("Generate optional fields using AI?")
                            .font(.Editorial.button)
                            .foregroundStyle(Color.primaryBrand)
                        
                        Spacer()
                        
                        Toggle("", isOn: $viewModel.shouldGenerateUsingAI)
                    }
                    .padding(.top)
                    
                    if !self.viewModel.shouldGenerateUsingAI {
                        self.optionalView
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            RoundedRectangleButton(buttonText: "Add Book",
                                   imageName: "") {
                Task { @MainActor in
                    do {
                        try await self.viewModel.addBookToDB(books: self.books)
                        self.router.popToRoot()
                    } catch {
                        
                    }
                }
            }.padding()
        }
        .navigationTitle("Add New Book")
        .sheet(isPresented: $viewModel.showAddGenresSheet) {
            NavigationStack {
                AddGenresView(addGenresToBook: { genresAdded in
                    self.viewModel.tags = genresAdded
                })
                .presentationDetents([.medium])
            }
        }
        .onAppear {
            if let coverImage {
                do {
                    try self.viewModel.extractText(from: coverImage.renderAsImage())
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .alert("Error", isPresented: $viewModel.errorOccured) {} message: {
            Text(self.viewModel.errorMessage ?? "")
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PrefillAddBookFields"))) { output in
            if let info = output.userInfo as? [String: Any] {
                let title = info["title"] as? String
                let author = info["author"] as? String
                let description = info["description"] as? String
                let themes = info["themes"] as? [String]
                withAnimation {
                    if let title { self.viewModel.bookTitle = title }
                    if let author { self.viewModel.authorName = author }
                    if let description { self.viewModel.bookDescription = description }
                    if let themes { self.viewModel.tags = themes.compactMap { BookGenre(rawValue: $0) } }
                }
            }
        }
        .onChange(of: self.viewModel.extractedBook) { _, extractedBook in
            guard let extractedBook else { return }
            
            withAnimation {
                self.viewModel.bookTitle = extractedBook.title
                self.viewModel.authorName = extractedBook.authorName.first ?? ""
                self.viewModel.bookDescription = extractedBook.bookDescription ?? ""
                self.viewModel.tags = (extractedBook.themes?.map { BookGenre(rawValue: $0) } as? [BookGenre]) ?? []
            }
        }
    }
    
    var optionalView: some View {
        Group {
            VStack(alignment: .leading) {
                HStack {
                    Text("Genres (Optional)")
                        .font(.Editorial.body)
                        .foregroundStyle(Color.primaryBrand)
                    
                    if !self.viewModel.tags.isEmpty {
                        Spacer()
                        Button {
                            self.viewModel.showAddGenresSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                
                HStack {
                    if self.viewModel.tags.isEmpty {
                        RoundedRectangleButton(buttonText: "Add Genres",
                                               imageName: nil,
                                               buttonFillColor: .neutralButton,
                                               buttonTextColor: .primaryBrand) {
                            self.viewModel.showAddGenresSheet.toggle()
                        }
                    } else {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5, alignment: .center), count: 2), spacing: 5) {
                            ForEach(self.viewModel.tags, id: \.self) { item in
                                RoundedRectangleButton(
                                    buttonText: item.rawValue,
                                    imageName: nil,
                                    buttonFillColor: .primaryBrand,
                                    buttonTextColor: .neutral,
                                    buttonBorderColor: .neutral,
                                    buttonPaddingHorizontal: 8,
                                    buttonPaddingVertical: 8
                                ) {
                                    self.viewModel.tags.removeAll { $0.rawValue == item.rawValue }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top)
            
            VStack(alignment: .leading) {
                Text("Description (Optional)")
                    .font(.Editorial.body)
                    .foregroundStyle(Color.primaryBrand)
                
                TextEditor(text: $viewModel.bookDescription)
                    .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
                    .font(.Editorial.body)
                    .overlay {
                        if self.viewModel.bookDescription.isEmpty {
                            Text("Add Book Description")
                                .foregroundStyle(.accent.opacity(0.3))
                                .position(x: 90, y: 20)
                        }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.accentColor.opacity(0.2), lineWidth: 1)
                    }
            }
            .padding(.top)
        }
    }
}
