//
//  CurrentlyReadingSection.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/02/26.
//

import SwiftUI

struct CurrentlyReadingSection: View {
    let currentlyReadingBookList: [BookModel]
    let viewModel: LibraryViewModel
    let onBookCardTap: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Currently Reading")
                .padding(.bottom, 16)
            
            if currentlyReadingBookList.isEmpty {
                emptyCurrentlyReadingView
            } else {
                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing: 20) {
                        ForEach(currentlyReadingBookList, id: \.id) { book in
                            Button {
                                self.onBookCardTap(book.id)
                            } label: {
                                VStack(alignment: .leading) {
                                    BookImage(bookImageURL: book.coverImageURL,
                                              bookImageData: book.coverImageData,
                                              bookTitle: book.title,
                                              imageFrame: (256, 341))
                                        .padding(.bottom, 12)
                                    
                                    Text(book.title)
                                        .font(.title3)
                                    
                                    Text(book.authorName.joined(separator: ", "))
                                        .padding(.bottom, 5)
                                }
                                .accessibilityLabel("\(book.title) card")
                            }
                            .buttonStyle(.plain)
                            .frame(width: 260)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .fontDesign(.serif)
    }
    
    var emptyCurrentlyReadingView: some View {
        VStack(alignment: .center, spacing: 5) {
            Image(systemName: "book.pages.fill")
                .resizable()
                .frame(width: 33, height: 36)
                .padding(.bottom, 10)
                
            Text("No books in progress")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Start reading something from your wishlist")
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                .fill(Color.neutralButton.opacity(0.1))
        }
    }
}
