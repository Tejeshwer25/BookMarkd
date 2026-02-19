//
//  DiscoverView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 08/01/26.
//

import SwiftUI
import _SwiftData_SwiftUI

struct DiscoverView: View {
    @EnvironmentObject private var router: Router
    @Query private var booksRead: [BookModel]
    
    @State private var recommendedBooks: [RecommendedBooks] = []
    @State private var loadingBooks: Bool = false
    @State private var showSearchModal: Bool = false
    @State private var searchQuery: String = ""
    
    var body: some View {
        ScrollView {
            if !self.recommendedBooks.isEmpty {
                RecommendedBooksView()
                    .padding(.bottom)
                
                ForEach(self.recommendedBooks, id: \.bookTitle) { book in
                    RecommendedBookComponent(bookTitle: book.bookTitle,
                                             author: book.bookAuthor,
                                             description: book.bookDescription,
                                             whyRecommend: book.whyRecommendation,
                                             addBookToWishlist: { authorName, bookTitle in
                        print("\(authorName) \(bookTitle)")
                        self.searchQuery = "\(authorName) \(bookTitle)"
                        self.showSearchModal.toggle()
                    })
                    .padding(.vertical, 5)
                }
                
                Button {
                    
                } label: {
                    HStack {
                        Text("Regenerate")
                        Image(systemName: "arrow.clockwise")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.brown)
                    }
                }
                .padding(.vertical)
                .buttonStyle(.plain)
            } else {
                VStack {}.frame(maxWidth: .infinity)
            }
        }
        .scrollIndicators(.hidden)
        .padding()
        .overlay {
            if self.loadingBooks {
                LoadingRecommendations()
            }
        }
        .overlay {
            if self.booksRead.isEmpty,
                self.recommendedBooks.isEmpty,
                !self.loadingBooks {
                VStack(alignment: .center) {
                    Spacer()
                    
                    Image(systemName: "moon.stars.fill")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .padding()
                    
                    Text("No recommendation available")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Try again later after choosing your genre or starting a new book")
                        .multilineTextAlignment(.center)
                        .padding(.top, 1)
                    
                    Spacer()
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .task {
            if self.recommendedBooks.isEmpty,
                !self.booksRead.isEmpty {
                do {
                    self.loadingBooks = true
                    self.recommendedBooks = try await RecommendationService().generateRecommendations(from: booksRead)
                    self.loadingBooks = false
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .sheet(isPresented: $showSearchModal) {
            AddBookView(query: $searchQuery)
        }
    }
}

#Preview {
    NavigationStack {
        DiscoverView()
    }
}
