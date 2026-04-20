//
//  HorizontalBookPreview.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 11/01/26.
//

import SwiftUI

struct HorizontalBookPreview: View {
    var book: BookModel
    var descriptionLineLimit: Int
    var imageFrame: (width: CGFloat, height: CGFloat) = (100, 150)
    
    var body: some View {
        HStack(spacing: 10) {
            if let coverImageURL = book.coverImageURL {
                BookImage(bookImageURL: coverImageURL, bookTitle: book.title, imageFrame: imageFrame)
            } else {
                BookImage(bookImageURL: "", bookTitle: book.title, imageFrame: imageFrame)
            }
            
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                
                Text(book.authorName.joined(separator: ", "))
                    .font(.subheadline)
                
                Text("A large book description that will compell the user to buy that book, but its not some marketing gimmick.")
                    .padding(.top)
                    .font(.footnote)
                    .lineLimit(descriptionLineLimit)
            }
        }
    }
}
