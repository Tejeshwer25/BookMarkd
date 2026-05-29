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
    let bookTitle: String
    @State private var image: UIImage?
    let onImageFetch: ((UIImage?) -> Void)?
    
    init(bookImageURL: String? = nil,
         bookImageData: Data? = nil,
         bookTitle: String,
         imageFrame: (width: CGFloat, height: CGFloat),
         onImageFetch: ((UIImage?) -> Void)? = nil) {
        self.bookImageURL = bookImageURL
        self.bookImageData = bookImageData
        self.imageFrame = imageFrame
        self.bookTitle = bookTitle
        self.onImageFetch = onImageFetch
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
            Task { @MainActor in
                if let bookImageURL, !bookImageURL.isEmpty {
                    image = await CachedImageLoaderActor.shared.load(from: URL(string: bookImageURL))
                } else if let bookImageData {
                    image = UIImage(data: bookImageData)
                } else if image == nil {
                    let newImage = PlaceholderBookCoverView(bookTitle: bookTitle,
                                                            width: imageFrame.width,
                                                            height: imageFrame.height).renderAsImage()
                    if image != nil { return }
                    
                    self.image = newImage
                }
                
                self.onImageFetch?(self.image)
            }
        }
        .onChange(of: bookImageData) { oldValue, newValue in
            Task { @MainActor in
                if let bookImageURL, !bookImageURL.isEmpty {
                    image = await CachedImageLoaderActor.shared.load(from: URL(string: bookImageURL))
                } else if let bookImageData {
                    image = UIImage(data: bookImageData)
                } else if image == nil {
                    let newImage = PlaceholderBookCoverView(bookTitle: bookTitle,
                                                            width: imageFrame.width,
                                                            height: imageFrame.height).renderAsImage()
                    if image != nil { return }
                    
                    self.image = newImage
                }
                self.onImageFetch?(self.image)
            }
        }
    }
}

