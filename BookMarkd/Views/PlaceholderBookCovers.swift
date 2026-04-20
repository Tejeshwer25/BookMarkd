//
//  PlaceholderBookCovers.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 20/04/26.
//

import SwiftUI

struct PlaceholderBookCoverView: View {
    let bookTitle: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Image(systemName: "book.closed.fill")
                    .resizable()
                    .foregroundStyle(.primaryBrand)
            }
            
            Text(bookTitle)
                .padding()
                .padding(.leading, 8)
                .foregroundStyle(.white)
                .lineLimit(3)
                .fontDesign(.serif)
                .fontWeight(.semibold)
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    PlaceholderBookCoverView(bookTitle: "A History of the Sikhs", width: 100, height: 125)
}
