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
                        self.viewModel.addOrRemoveFromWishlist(book)
                    } label: {
                        Image(systemName: self.viewModel.booksWishlisted.contains(where: { $0 == book.id }) ? "bookmark.fill" : "bookmark")
                            .resizable()
                            .frame(width: 20, height: 25)
                            .contentTransition(.symbolEffect(.automatic))
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
