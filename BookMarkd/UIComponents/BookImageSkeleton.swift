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
            .overlay {
                ProgressView()
            }
    }
}

struct BookImage: View {
    var bookImageURL: String? = nil
    var bookImageData: Data? = nil
    var imageFrame: (width: CGFloat, height: CGFloat) = (100, 150)
    @State private var image: UIImage?
    
    init(bookImageURL: String? = nil,
         bookImageData: Data? = nil,
         imageFrame: (width: CGFloat, height: CGFloat)) {
        self.bookImageURL = bookImageURL
        self.bookImageData = bookImageData
        self.imageFrame = imageFrame
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: self.imageFrame.width, height: self.imageFrame.height)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                BookImageSkeleton()
                    .frame(width: self.imageFrame.width, height: self.imageFrame.height)
            }
        }
        .onChange(of: bookImageURL, initial: true) { oldValue, newValue in
            Task {
                if let bookImageURL, !bookImageURL.isEmpty {
                    image = await CachedImageLoaderActor.shared.load(from: URL(string: bookImageURL))
                } else if let bookImageData {
                    image = UIImage(data: bookImageData)
                }
            }
        }
        .onChange(of: bookImageData) { oldValue, newValue in
            Task {
                if let bookImageURL, !bookImageURL.isEmpty {
                    image = await CachedImageLoaderActor.shared.load(from: URL(string: bookImageURL))
                } else if let bookImageData {
                    image = UIImage(data: bookImageData)
                }
            }
        }
    }
}

