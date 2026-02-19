//
//  AddBookView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 11/01/26.
//

import SwiftUI
import _SwiftData_SwiftUI

struct AddBookView: View {
    let hapticsManager = HapticManager.shared
    @Binding var query: String
    
    @Query private var booksInLibrary: [BookModel]
    @EnvironmentObject private var store: StorageManageer
    
    @State private var bookTitle: String = ""
    @State private var books: [SearchedBooks] = []
    @State private var debouncedTask: Task<Void, Never>? = nil
    @State private var loading: Bool = false
    @State private var booksWishlisted: [String] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Add to Wishlist")
                .font(.title)
                .fontDesign(.serif)
            Text("Curate your next reading adventure.")
                .fontDesign(.serif)
            
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
            .padding(.top)
            
            if !self.books.isEmpty {
                List{
                    Section("Searched Results") {
                        ForEach(self.books, id: \.id) { book in
                            HStack(spacing: 10) {
                                BookImage(bookImageURL: book.coverImageURL ?? "",
                                          imageFrame: (100, 150))
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(book.title)
                                        .font(.title3)
                                        .fontDesign(.serif)
                                    
                                    Text(book.authorName.joined(separator: ", "))
                                        .fontDesign(.serif)
                                        .font(.callout)
                                }
                                
                                Spacer()
                                
                                Button {
                                    hapticsManager.trigger(.impactMedium)
                                    self.addBookToWishlist(book)
                                } label: {
                                    Image(systemName: self.booksWishlisted.contains(where: { $0 == book.id }) ? "bookmark.fill" : "bookmark")
                                        .resizable()
                                        .frame(width: 20, height: 25)
                                        .contentTransition(.symbolEffect(.automatic))
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.leading, 5)
                            .padding(.top, 10)
                            .padding(.bottom, 15)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listRowInsets(EdgeInsets())
                }
                .padding(.vertical, 30)
            } else if self.bookTitle.isEmpty && !self.loading {
                Spacer()
                self.emptyListView
            } else if self.loading {
                // loading screen
            } else {
                // errror screen
            }
            
            
            Spacer()
        }
        .padding(.top)
        .padding()
        .overlay {
            if self.loading {
                ProgressView()
            }
        }
        .onChange(of: bookTitle) { oldValue, newValue in
            self.debouncedTask?.cancel()
            
            if !newValue.isEmpty {
                self.debouncedTask = Task {
                    self.loading = true
                    self.books = []
                    let searchResult = await searchBook(newValue)
                    
                    if !searchResult.isEmpty {
                        self.books = searchResult.filter({ book in
                            let isPresent = self.booksInLibrary.contains(where: { $0.id == book.id })
                            return !isPresent
                        })
                        self.loading = false
                    }
                }
            } else {
                self.loading = false
            }
        }
        .onAppear {
            if !self.query.isEmpty {
                self.bookTitle = self.query
            }
        }
    }
    
    var emptyListView: some View {
        VStack(alignment: .center) {
            Image(systemName: "book.circle")
                .resizable()
                .frame(width: 75, height: 75)
                .padding()
            
            Text("Begin your search to \nadd to your library")
                .font(.title2)
                .fontDesign(.serif)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
            
            Text("Your personal collection of forgotten scrolls and future adventures awaits within the midnight shadows.")
                .font(.subheadline)
                .fontDesign(.serif)
                .multilineTextAlignment(.center)
                .italic()
        }
        .opacity(1)
        .padding()
    }
    
    func addBookToWishlist(_ book: SearchedBooks) {
        let bookModel = BookModel(id: book.id,
                                  title: book.title,
                                  authorName: book.authorName,
                                  readState: book.readState)
        
        if self.booksWishlisted.contains(where: { $0 == book.id}) {
            self.store.removeBook(bookModel.id)
            withAnimation {
                self.booksWishlisted.removeAll(where: { $0 == book.id })
            }
        } else {
            bookModel.readState = .wishlist
            self.store.addBook(bookModel)
            withAnimation {
                self.booksWishlisted.append(book.id)
            }
        }
    }
    
    func searchBook(_ bookName: String) async -> [SearchedBooks] {
        if let url = URL(string: "https://openlibrary.org/search.json") {
            let service = BookServiceUtility(api: .init(baseURL: url))
            do {
                let books = try await service.searchBooks(bookName)
                return books
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return []
    }
}

#Preview {    
    AddBookView(query: .constant(""))
}
