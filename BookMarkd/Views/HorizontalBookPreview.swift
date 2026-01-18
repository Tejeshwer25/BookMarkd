//
//  HorizontalBookPreview.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 11/01/26.
//

import SwiftUI

struct HorizontalBookPreview: View {
    var bookName: String
    var descriptionLineLimit: Int
    var imageFrame: (width: CGFloat, height: CGFloat) = (100, 150)
    
    var body: some View {
        HStack(spacing: 10) {
            BookImage(bookImageURL: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400", imageFrame: imageFrame)
            
            VStack(alignment: .leading) {
                Text(bookName)
                    .font(.headline)
                
                Text("Author Name")
                    .font(.subheadline)
                
                Text("A large book description that will compell the user to buy that book, but its not some marketing gimmick.")
                    .padding(.top)
                    .font(.footnote)
                    .lineLimit(descriptionLineLimit)
            }
        }
    }
}

#Preview {
    HorizontalBookPreview(bookName: "Test", descriptionLineLimit: 3)
}
