//
//  AddBookManuallyView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 22/03/26.
//

import SwiftUI
import PhotosUI
import _SwiftData_SwiftUI
import Vision
import Foundation

@MainActor
struct AddBookManuallyView: View {
    @EnvironmentObject private var router: Router
    @Query private var books: [BookModel]
    
    @State private var bookTitle: String = ""
    @State private var authorName: String = ""
    @State private var tags: [BookGenre] = []
    @State private var bookDescription: String = ""
    @State private var addBookToState: BookReadingState = .wishlist
    @State private var shouldGenerateUsingAI: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var coverImage: Image? = nil
    @State private var coverImageData: Data? = nil
    @State private var showAddGenresSheet: Bool = false
    @State private var extractedText: String = ""
    @State private var errorOccured: Bool = false
    @State private var errorMessage: String? = nil
    
    let bookRepository: any BookRepository
    
    init(bookRepository: any BookRepository, bookImage: UIImage? = nil) {
        self.bookRepository = bookRepository
        
        if let bookImage {
            self._coverImage = State(initialValue: Image(uiImage: bookImage))
            self._coverImageData = State(initialValue: bookImage.pngData())
        } else {
            self._coverImage = State(initialValue: nil)
            self._coverImageData = State(initialValue: nil)
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
                                    self.coverImageData = data
                                }
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
                        Text("Add to State")
                            .font(.Editorial.body)
                            .foregroundStyle(Color.primaryBrand)
                        
                        Spacer()
                        
                        Picker(selection: $addBookToState) {
                            Text("Select a value").tag(nil as String?)
                            
                            ForEach(BookReadingState.allCases, id: \.self) { flavor in
                                Text(flavor.rawValue.capitalized).tag(flavor)
                            }
                        } label: {
                            Text(addBookToState.rawValue.capitalized)
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
        .onAppear {
            if let coverImage {
                self.extractText(from: coverImage.renderAsImage())
            }
        }
        .alert("Error", isPresented: $errorOccured) {} message: {
            Text(self.errorMessage ?? "")
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PrefillAddBookFields"))) { output in
            if let info = output.userInfo as? [String: Any] {
                let title = info["title"] as? String
                let author = info["author"] as? String
                let description = info["description"] as? String
                let themes = info["themes"] as? [String]
                withAnimation {
                    if let title { self.bookTitle = title }
                    if let author { self.authorName = author }
                    if let description { self.bookDescription = description }
                    if let themes { self.tags = themes.compactMap { BookGenre(rawValue: $0) } }
                }
            }
        }
    }
    
    /// Method to add book to DB
    func addBookToDB() async throws {
        guard !self.bookTitle.isEmpty, !self.authorName.isEmpty else {
            self.errorMessage = "Data empty! Book cannot be added"
            self.errorOccured = true
            return
        }
        
        print(self.books.map(\.title))
        if self.books.contains(where: { $0.title.lowercased() == self.bookTitle.lowercased() }) {
            self.errorMessage = "Book already exists in library."
            self.errorOccured = true
            return
        }
        
        var newBook = BookModel(id: UUID().uuidString,
                                title: self.bookTitle,
                                authorName: [self.authorName],
                                readState: self.addBookToState,
                                bookDescription: self.bookDescription,
                                coverImageData: self.coverImageData,
                                isManuallyCreated: true,
                                themes: self.tags.map{$0.rawValue})
        
        do {
            if shouldGenerateUsingAI {
                let recommendationService = RecommendationService()
                newBook = try await recommendationService.generateBookDescriptionAndGenres(for: newBook)
            }
            
            try self.bookRepository.add(newBook)
            self.router.popScreen()
        } catch {
            print(error.localizedDescription)
            self.errorOccured = true
            if let error = error as? FoundationModelErrors {
                self.errorMessage = error.errorDescription
            } else if let error = error as? PersistenceError {
                self.errorMessage = error.errrorDescription
            } else {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    /// Method to extract text from imported image
    /// - Parameter image: imported image
    func extractText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        // Set up the request for text recognition
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                self.errorMessage = "Cover recognition failed: \(error.localizedDescription)"
                self.errorOccured = true
                return
            }
            
            // Process the results from the Vision request
            if let observations = request.results as? [VNRecognizedTextObservation] {
                // Extract the top-most recognized text
                var fullText = ""
                for observation in observations {
                    guard let topCandidate = observation.topCandidates(1).first else { continue }
                    fullText += topCandidate.string + "\n"
                }
                
                Task {
                    do {
                        let extractedBook = try await RecommendationService().getBookDetailsFromBookCover(for: fullText)
                        await MainActor.run {
                            withAnimation {
                                self.bookTitle = extractedBook.title
                                self.authorName = extractedBook.authorName.first ?? ""
                                self.bookDescription = extractedBook.bookDescription ?? ""
                                self.tags = (extractedBook.themes?.map { BookGenre(rawValue: $0) } as? [BookGenre]) ?? []
                            }
                        }
                    } catch {
                        if let error = error as? FoundationModelErrors {
                            self.errorMessage = error.errorDescription
                        } else {
                            self.errorMessage = error.localizedDescription
                        }
                        
                        self.errorOccured = true
                    }
                }
                
            }
        }
        
        // Perform the text recognition
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([request])
        } catch {
            self.errorMessage = "Cover recognition failed: \(error.localizedDescription)"
            self.errorOccured = true
        }
    }
}

