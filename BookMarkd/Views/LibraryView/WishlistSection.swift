//
//  WishlistSection.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/03/26.
//

import SwiftUI

struct WishlistSection: View {
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
                            .foregroundStyle(Color.yellow)
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
            Image(systemName: "checkmark.circle")
                .resizable()
                .frame(width: 36, height: 36)
                .padding(.bottom, 10)
            
            Text("Your wishlist section is empty")
                .font(.headline)
            
            Text("Save books you want to read later")
            
            Button {
                
            } label: {
                Text("Discover Books")
                    .foregroundStyle(Color.yellow)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    .background {
                        Capsule()
                            .stroke(Color.yellow, lineWidth: 1)
                            .fill(Color.brown.opacity(0.2))
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
                .fill(Color.blue.opacity(0.1))
        }
    }
}
