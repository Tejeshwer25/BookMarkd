//
//  AddBookSearchResults.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 22/03/26.
//

import SwiftUI
import Combine

struct AddBookSearchResults: View {
    @ObservedObject var viewModel: AddBookViewModel
    let hapticsManager = HapticManager.shared
    
    var body: some View {
        List{
            ForEach(self.viewModel.books, id: \.id) { book in
                HStack(spacing: 10) {
                    BookImage(bookImageURL: book.coverImageURL ?? "",
                              bookTitle: book.title, imageFrame: (100, 150))
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(book.title)
                            .font(EditorialSerif.displayMedium)
                        
                        Text(book.authorName.joined(separator: ", "))
                            .font(EditorialSans.bodyMedium)
                            .foregroundStyle(Color.SURFACE_LOW)
                    }
                    
                    Spacer()
                    
                    Button {
                        hapticsManager.trigger(.impactMedium)
                        self.viewModel.addOrRemoveFromWishlist(book)
                    } label: {
                        Image(systemName: self.viewModel.booksWishlisted.contains(where: { $0 == book.id }) ? "bookmark.fill" : "bookmark")
                            .resizable()
                            .frame(width: 20, height: 25)
                            .contentTransition(.symbolEffect(.automatic))
                            .accessibilityLabel("Add to wishlist")
                    }
                    .buttonStyle(.plain)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}
