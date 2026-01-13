//
//  BookImageSkeleton.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 13/01/26.
//

import SwiftUI

struct BookImageSkeleton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundStyle(.gray)
    }
}

struct BookImage: View {
    var bookImageURL: String
    var imageFrame: (width: CGFloat, height: CGFloat) = (100, 150)
    
    var body: some View {
        AsyncImage(url: URL(string: bookImageURL)) { image in
            image
                .resizable()
                .frame(width: self.imageFrame.width, height: self.imageFrame.height)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } placeholder: {
            BookImageSkeleton()
                .frame(width: self.imageFrame.width, height: self.imageFrame.height)
        }
    }
}
