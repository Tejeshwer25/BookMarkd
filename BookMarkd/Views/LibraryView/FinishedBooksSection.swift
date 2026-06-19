//
//  FinishedBooksSection.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/02/26.
//

import SwiftUI

struct FinishedBooksSection: View {
    let viewModel: LibraryViewModel
    let finishedBookList: [BookModel]
    let onBookComponentTap: (String) -> Void
    let viewAllFinishedBooks: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderComponent(headerTitle: "Recent Finish") {
                if self.finishedBookList.count > 5 {
                    Button {
                        self.viewAllFinishedBooks()
                    } label: {
                        Text("Archive")
                            .foregroundStyle(Color.primaryBrand)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.bottom, 16)
            
            self.finishedBookView
        }
    }
    
    var finishedBookView: some View {
        VStack(alignment: .leading) {
            ForEach(self.finishedBookList.prefix(upTo: self.finishedBookList.count > 5 ? 5 : self.finishedBookList.count)) { book in
                Button {
                    self.onBookComponentTap(book.id)
                } label: {
                    HStack {
                        BookImage(bookImageURL: book.coverImageURL,
                                  bookImageData: book.coverImageData,
                                  bookTitle: book.title,
                                  imageFrame: (100, 150))
                        
                        VStack(alignment: .leading) {
                            Text(book.title)
                                .font(.headline)
                                .lineLimit(3)
                            
                            Text(book.authorName.joined(separator: ", "))
                            
                            StarRatingView(rating: book.rating ?? 0, starSize: 15)
                        }
                        
                        Spacer(minLength: 25)
                        
                        VStack {
                            Text("FINISHED")
                                .fontWeight(.bold)
                            
                            Text(self.viewModel.getFinishedBookDate(book: book))
                        }
                        .font(.caption)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondaryBrand.opacity(0.2), lineWidth: 1)
                            .fill(Color.neutralButton.opacity(0.2))
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .fontDesign(.serif)
    }
}
