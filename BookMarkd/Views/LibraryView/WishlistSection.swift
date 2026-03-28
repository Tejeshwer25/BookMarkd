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
    
    var body: some View {
        if self.wishlishtedBooks.isEmpty {
            self.emptyFinishedBooksView
        } else {
            self.finishedBookView
        }
    }
    
    var finishedBookView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Wishlist")
                    .font(.title3)
                
                Spacer()
                
                if self.wishlishtedBooks.count > 2 {
                    Button {
                        
                    } label: {
                        Text("View All")
                            .foregroundStyle(Color.primaryBrand)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 25) {
                    ForEach(self.wishlishtedBooks) { book in
                        Button {
                            self.onBookComponentTap(book.id)
                        } label: {
                            VStack(alignment: .leading) {
                                BookImage(bookImageURL: book.coverImageURL ?? "",
                                          bookImageData: book.coverImageData,
                                          imageFrame: (103, 137))
                                
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                        .font(.headline)
                                    
                                    Text(book.authorName.joined(separator: ", "))
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
        .fontDesign(.serif)
    }
    
    var emptyFinishedBooksView: some View {
        VStack(alignment: .center, spacing: 5) {
            Image(systemName: "bookmark.circle")
                .resizable()
                .frame(width: 36, height: 36)
                .padding(.bottom, 10)
            
            Text("Your wishlist section is empty")
                .font(.headline)
            
            Text("Save books you want to read later")
            
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
    }
}
