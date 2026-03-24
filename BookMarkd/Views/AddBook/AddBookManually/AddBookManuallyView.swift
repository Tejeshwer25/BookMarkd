//
//  AddBookManuallyView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 22/03/26.
//

import SwiftUI
import PhotosUI
import _SwiftData_SwiftUI

@MainActor
struct AddBookManuallyView: View {
    @EnvironmentObject private var router: Router
    @Query private var books: [BookModel]
    
    @State private var bookTitle: String = ""
    @State private var authorName: String = ""
    @State private var tags: [BookGenre] = []
    @State private var bookDescription: String = ""
    @State private var addBookToState: BookReadingState? = nil
    @State private var shouldGenerateUsingAI: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var coverImage: Image? = nil
    @State private var coverImageData: Data? = nil
    @State private var showAddGenresSheet: Bool = false
    
    let bookRepository: any BookRepository
    
    var body: some View {
        let currentCoverImage = coverImage
        
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
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
                                self.coverImageData = data
                            }
                        }
                    }
                    
                    TextField("Book Title", text: $bookTitle)
                        .font(.Editorial.bookTitle)
                        .padding(.top)
                    
                    TextField("Author Name", text: $authorName)
                        .font(.Editorial.sectionTitle)
                        .padding(.top)
                    
                    HStack {
                        Text("Add to State (Optional)")
                            .font(.Editorial.body)
                            .foregroundStyle(Color.primaryBrand)
                        
                        Spacer()
                        
                        Picker(selection: $addBookToState) {
                            Text("Select a value").tag(nil as String?)
                            
                            ForEach(BookReadingState.allCases, id: \.self) { flavor in
                                Text(flavor.rawValue.capitalized).tag(flavor)
                            }
                        } label: {
                            Text(addBookToState?.rawValue.capitalized ?? "Select a value")
                        }
                        .pickerStyle(.menu)
                    }
                    .padding(.top)
                    
                    HStack {
                        Text("Generate optional fields using AI?")
                            .font(.Editorial.button)
                            .foregroundStyle(Color.primaryBrand)
                        
                        Spacer()
                        
                        Toggle("", isOn: $shouldGenerateUsingAI)
                    }
                    .padding(.top)
                    
                    if !shouldGenerateUsingAI {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Genres (Optional)")
                                    .font(.Editorial.body)
                                    .foregroundStyle(Color.primaryBrand)
                                
                                if !tags.isEmpty {
                                    Spacer()
                                    Button {
                                        self.showAddGenresSheet.toggle()
                                    } label: {
                                        Image(systemName: "plus")
                                    }
                                }
                            }
                            
                            HStack {
                                if tags.isEmpty {
                                    RoundedRectangleButton(buttonText: "Add Genres",
                                                           imageName: nil,
                                                           buttonFillColor: .neutralButton,
                                                           buttonTextColor: .primaryBrand) {
                                        self.showAddGenresSheet.toggle()
                                    }
                                } else {
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5, alignment: .center), count: 2), spacing: 5) {
                                        ForEach(self.tags, id: \.self) { item in
                                            RoundedRectangleButton(
                                                buttonText: item.rawValue,
                                                imageName: nil,
                                                buttonFillColor: .primaryBrand,
                                                buttonTextColor: .neutral,
                                                buttonBorderColor: .neutral,
                                                buttonPaddingHorizontal: 8,
                                                buttonPaddingVertical: 8
                                            ) {
                                                self.tags.removeAll { $0.rawValue == item.rawValue }
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
                            
                            TextEditor(text: $bookDescription)
                                .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
                                .font(.Editorial.body)
                                .overlay {
                                    if bookDescription.isEmpty {
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
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            RoundedRectangleButton(buttonText: "Add Book",
                                   imageName: "") {
                Task { @MainActor in
                    try? await self.addBookToDB()
                }
            }
                                   .padding()
        }
        .navigationTitle("Add New Book")
        .sheet(isPresented: $showAddGenresSheet) {
            NavigationStack {
                AddGenresView(addGenresToBook: { genresAdded in
                    self.tags = genresAdded
                })
                .presentationDetents([.medium])
            }
        }
    }
    
    /// Method to add book to DB
    func addBookToDB() async throws {
        guard !self.bookTitle.isEmpty, !self.authorName.isEmpty else {
            print("Show alert here: Data Empty book cannot be added")
            return
        }
        
        print(self.books.map(\.title))
        if self.books.contains(where: { $0.title.lowercased() == self.bookTitle.lowercased() }) {
            print("Show alert here : Book Exists")
            return
        }
        
        var newBook = BookModel(id: UUID().uuidString,
                                title: self.bookTitle,
                                authorName: [self.authorName],
                                readState: self.addBookToState ?? .wishlist,
                                bookDescription: self.bookDescription,
                                coverImageData: self.coverImageData,
                                isManuallyCreated: true,
                                themes: self.tags.map{$0.rawValue})
        
        if shouldGenerateUsingAI {
            let recommendationService = RecommendationService()
            newBook = try await recommendationService.generateBookDescriptionAndGenres(for: newBook)
            
        }
        
        do {
            try self.bookRepository.add(newBook)
            self.router.popScreen()
        } catch {
            print(error.localizedDescription)
        }
    }
}

