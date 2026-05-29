//
//  CurrentlyReadingSection.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/02/26.
//

import SwiftUI
import UIKit

struct CurrentlyReadingSection: View {
    let currentlyReadingBookList: [BookModel]
    let viewModel: LibraryViewModel
    let onBookCardTap: (String) -> Void
    @State private var dominantColor: Color = Color.SURFACE_LOW
    
    // MARK: - Dominant color extraction
    private func getDominantColor(from image: UIImage?) -> Color {
        guard let image = image,
                let cgImage = image.cgImage else { return Color.SURFACE_LOW }
        
        let width = 40
        let height = 40
        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var rawData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)
        guard let context = CGContext(data: &rawData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return Color.SURFACE_LOW
        }
        context.interpolationQuality = .low
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        var rTotal: UInt64 = 0
        var gTotal: UInt64 = 0
        var bTotal: UInt64 = 0
        var aTotal: UInt64 = 0
        let count = width * height
        var index = 0
        for _ in 0..<count {
            let r = rawData[index]
            let g = rawData[index+1]
            let b = rawData[index+2]
            let a = rawData[index+3]
            rTotal += UInt64(r)
            gTotal += UInt64(g)
            bTotal += UInt64(b)
            aTotal += UInt64(a)
            index += 4
        }
        
        let r = Double(rTotal) / Double(count) / 255.0
        let g = Double(gTotal) / Double(count) / 255.0
        let b = Double(bTotal) / Double(count) / 255.0
        let a = Double(aTotal) / Double(count) / 255.0
        // Use averaged alpha to avoid fully transparent results
        let base = Color(red: r, green: g, blue: b, opacity: max(a, 1.0))
        return base
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Currently Reading")
                .padding(.bottom, 16)
                .font(EditorialSerif.displayMedium)
                .foregroundStyle(Color.ON_SURFACE)
            
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
                                              imageFrame: (256, 341)) { image in
                                        withAnimation(.easeInOut(duration: 1)) {
                                            self.dominantColor = self.getDominantColor(from: image)
                                        }
                                    }
                                        .padding(.bottom, 12)

                                    Text(book.title)
                                        .font(EditorialSerif.headlineLarge)
                                        .foregroundStyle(Color.ON_SURFACE)
                                        .lineLimit(2)
                                        .truncationMode(.tail)
                                        .fixedSize(horizontal: false, vertical: true)

                                    Text(book.authorName.joined(separator: ", "))
                                        .padding(.bottom, 5)
                                        .font(EditorialSans.bodyMedium)
                                        .foregroundStyle(Color.SECONDARY_TEXT)
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(self.dominantColor.opacity(0.07))
                                )
                            }
                            .buttonStyle(.plain)
                            .frame(width: 260)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    var emptyCurrentlyReadingView: some View {
        VStack(alignment: .center, spacing: 5) {
            Image(systemName: "book.pages.fill")
                .resizable()
                .frame(width: 33, height: 36)
                .padding(.bottom, 10).foregroundStyle(Color.PRIMARY_BRAND)
                
            Text("No books in progress")
                .font(EditorialSerif.emptyState)
                .foregroundStyle(Color.ON_SURFACE)
                .multilineTextAlignment(.center)
            
            Text("Start reading something from your wishlist")
                .font(EditorialSans.bodyMedium)
                .foregroundStyle(Color.ON_SURFACE)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.ghostBorder, lineWidth: 1)
                .fill(Color.SURFACE_LOW)
        }
        .padding(.bottom, 20)
    }
}
