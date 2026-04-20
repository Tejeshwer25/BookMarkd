//
//  BookListView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 09/04/26.
//

import SwiftUI

struct BookListView: View {
    let bookList: [BookModel]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 25) {
                ForEach(bookList) { book in
                    VStack(alignment: .leading) {
                        BookImage(bookImageURL: book.coverImageURL ?? "",
                                  bookImageData: book.coverImageData,
                                  bookTitle: book.title, 
                                  imageFrame: (150, 200))
                        
                        VStack(alignment: .leading) {
                            Text(book.title)
                                .font(.headline)
                                .lineLimit(1)
                            
                            Text(book.authorName.joined(separator: ", "))
                                .lineLimit(1)
                        }
                        .frame(width: 150)
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle(bookList.first?.readState.rawValue.capitalized ?? "Books")
        .navigationBarTitleDisplayMode(.inline)
    }
}
