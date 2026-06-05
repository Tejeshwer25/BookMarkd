//
//  WishlistSection.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/03/26.
//

import SwiftUI

struct WishlistSection: View {
    @EnvironmentObject private var router: Router
    
    let viewModel: LibraryViewModel
    let wishlishtedBooks: [BookModel]
    let onBookComponentTap: (String) -> Void
    let viewAllFinishedBooks: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderComponent(headerTitle: "Wishlist") {
                if self.wishlishtedBooks.count > 5 {
                    Button {
                        self.viewAllFinishedBooks()
                    } label: {
                        Text("View All")
                            .foregroundStyle(Color.primaryBrand)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.bottom, 16)
            
            if self.wishlishtedBooks.isEmpty {
                EmptyStateView(imageName: "bookmark.circle",
                               imageSize: (width: 36, height: 36),
                               titleText: "Your wishlist section is empty") {
                    Button {
                        self.router.pushScreen(.addBookScreen)
                    } label: {
                        Text("Discover Books")
                            .foregroundStyle(Color.secondaryBrand)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background {
                                Capsule()
                                    .stroke(Color.secondaryBrand, lineWidth: 1)
                                    .fill(Color.neutralButton.opacity(0.2))
                            }
                    }
                    .padding(.top)
                    .buttonStyle(.plain)
                }
                .fontDesign(.serif)
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        .fill(Color.neutralButton.opacity(0.1))
                }
            } else {
                self.wishlistedBooksView
            }
        }
    }
    
    var wishlistedBooksView: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 25) {
                    ForEach(self.wishlishtedBooks.prefix(upTo: self.wishlishtedBooks.count > 5 ? 5 : self.wishlishtedBooks.count)) { book in
                        Button {
                            self.onBookComponentTap(book.id)
                        } label: {
                            VStack(alignment: .leading) {
                                BookImage(bookImageURL: book.coverImageURL ?? "",
                                          bookImageData: book.coverImageData,
                                          bookTitle: book.title,
                                          imageFrame: (125, 175))
                                
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                        .font(EditorialSerif.headlineMedium)
                                        .foregroundStyle(Color.ON_SURFACE)
                                        .lineLimit(2)
                                    
                                    Text(book.authorName.joined(separator: ", "))
                                        .font(EditorialSans.label)
                                        .foregroundStyle(Color.SECONDARY_TEXT)
                                }
                            }
                            .frame(width: 125)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
    
    var emptyFinishedBooksView: some View {
        VStack(alignment: .center, spacing: 5) {
        }
        
    }
}
