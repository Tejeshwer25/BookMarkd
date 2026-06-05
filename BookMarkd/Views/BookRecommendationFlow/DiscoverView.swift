//
//  DiscoverView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 08/01/26.
//

import SwiftUI
import SwiftData

struct DiscoverView: View {
    @EnvironmentObject private var router: Router
    @Query private var booksRead: [BookModel]
    @Query private var preferences: [UserPreferenceModel]
    @StateObject private var viewModel = BookRecommendationViewModel()
    
    var body: some View {
        ScrollView {
            if !self.viewModel.recommendedBooks.isEmpty {
                RecommendedBooksView()
                    .padding(.bottom)
                
                ForEach(self.viewModel.recommendedBooks, id: \.bookTitle) { book in
                    RecommendedBookComponent(bookTitle: book.bookTitle,
                                             author: book.bookAuthor,
                                             description: book.bookDescription,
                                             whyRecommend: book.whyRecommendation,
                                             addBookToWishlist: { authorName, bookTitle in
                        self.viewModel.searchQuery = "\(authorName) \(bookTitle)"
                        self.router.pushScreen(.addBook(query: self.viewModel.searchQuery))
                    })
                    .padding(.vertical, 5)
                }
                
                Button {
                    Task {
                        await self.viewModel.generateBookRecommendations(booksInLibrary: self.booksRead,
                                                                         preferences: self.preferences)
                    }
                } label: {
                    HStack {
                        Text("Regenerate")
                        Image(systemName: "arrow.clockwise")
                    }
                    .primaryButtonLabelStyle()
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.PRIMARY_BRAND)
                    }
                }
                .padding(.vertical)
                .buttonStyle(.plain)
            } else {
                VStack {}.frame(maxWidth: .infinity)
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal)
        .overlay {
            if self.viewModel.loadingBooks {
                LoadingRecommendations()
            }
        }
        .overlay {
            if self.booksRead.isEmpty,
               self.viewModel.shouldShowNoResultsLabel() {
                EmptyStateView(imageName: "moon.stars.fill",
                               imageSize: (width: 75, height: 75),
                               titleText: "No recommendation available",
                               subtitleText: "Try again later after choosing your genre or starting a new book")
                .padding(.horizontal)
            }
        }
        .task {
            if self.viewModel.recommendedBooks.isEmpty,
                !self.booksRead.isEmpty {
                await self.viewModel.generateBookRecommendations(booksInLibrary: self.booksRead, preferences: self.preferences)
            } else if self.viewModel.recommendedBooks.isEmpty == false {
                self.viewModel.refreshRecommendedBooks(booksInLibrary: self.booksRead)
            }
        }
    }
}
