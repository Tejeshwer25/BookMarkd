//
//  AddBookView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 11/01/26.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var bookTitle: String = ""
    @State private var books: [BookModel] = []
    @State private var bookAdded: String = ""
    @State private var debouncedTask: Task<Void, Never>? = nil
    
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
                        self.addBookToWishlist(book.id)
                    } label: {
                        Image(systemName: self.bookAdded == book.id ? "bookmark.fill" : "bookmark")
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
        .onChange(of: bookTitle) { oldValue, newValue in
            self.debouncedTask?.cancel()
            
            self.debouncedTask = Task {
                try? await Task.sleep(nanoseconds: 500_000_000)
                let searchResult = await searchBook(newValue)
                
                if !searchResult.isEmpty {
                    self.books = searchResult
                }
            }
        }
    }
    
    func addBookToWishlist(_ bookID: String) {
        withAnimation(completionCriteria: .logicallyComplete) {
            self.bookAdded = bookID
        } completion: {
            dismiss()
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
