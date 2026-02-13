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
    let bookImageURL: String
    var imageFrame: (width: CGFloat, height: CGFloat) = (100, 150)
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: self.imageFrame.width, height: self.imageFrame.height)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                BookImageSkeleton()
                    .frame(width: self.imageFrame.width, height: self.imageFrame.height)
            }
        }
        .onChange(of: bookImageURL, initial: true) { oldValue, newValue in
            Task {
                image = await CachedImageLoaderActor.shared.load(from: URL(string: bookImageURL))
            }
        }
    }
}

