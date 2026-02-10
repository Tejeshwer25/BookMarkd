//
//  AddBookView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 11/01/26.
//

import SwiftUI

struct AddBookView: View {
    @EnvironmentObject private var store: StorageManageer
    @State private var bookTitle: String = ""
    @State private var books: [BookModel] = []
    @State private var debouncedTask: Task<Void, Never>? = nil
    @State private var loading: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Add Book")
                .font(.title)
                .fontWeight(.bold)
            
            Divider()
            
            VStack(alignment: .leading) {
                TextField("Search to add", text: self.$bookTitle)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                    }
                    .padding(.top, 5)
            }
            .padding(.top)
            
            List(self.books) { book in
                HStack {
                    HorizontalBookPreview(book: book, descriptionLineLimit: 3)
                    
                    Spacer(minLength: 25)
                    
                    Button {
                        self.addBookToWishlist(book)
                    } label: {
                        Image(systemName: self.store.getBookList().contains(where: { $0.id == book.id }) ? "bookmark.fill" : "bookmark")
                            .resizable()
                            .frame(width: 20, height: 25)
                            .contentTransition(.symbolEffect(.automatic))
                    }
                    .buttonStyle(.plain)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .padding()
        .overlay {
            if self.loading {
                ProgressView()
            } else if self.books.isEmpty {
                self.emptyListView
            }
        }
        .onChange(of: bookTitle) { oldValue, newValue in
            self.debouncedTask?.cancel()
            
            self.debouncedTask = Task {
                try? await Task.sleep(nanoseconds: 500_000_000)
                self.loading = true
                self.books = []
                let searchResult = await searchBook(newValue)
                
                if !searchResult.isEmpty {
                    self.books = searchResult
                    self.loading = false
                }
            }
        }
    }
    
    var emptyListView: some View {
        VStack(alignment: .center) {
            Image(systemName: self.bookTitle.isEmpty ? "book.circle" :  "magnifyingglass.circle.fill")
                .resizable()
                .frame(width: 75, height: 75)
                .padding()
            
            Text(self.bookTitle.isEmpty ? "Searched books will appear here" : "No books found!")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(self.bookTitle.isEmpty ? "" : "Narrow down you search or try with a different keyword")
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .opacity(self.bookTitle.isEmpty ? 0.5 : 1)
        .padding()
    }
    
    func addBookToWishlist(_ book: BookModel) {
        withAnimation {
            self.store.addOrRemoveFromWishlist(book: book)
        }
    }
    
    func searchBook(_ bookName: String) async -> [BookModel] {
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
    AddBookView()
}
