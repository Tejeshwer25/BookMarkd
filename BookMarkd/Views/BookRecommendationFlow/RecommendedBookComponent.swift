//
//  RecommendedBookComponent.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/02/26.
//

import SwiftUI

struct RecommendedBookComponent: View {
    let bookTitle: String
    let author: String
    let description: String
    let whyRecommend: String
    let addBookToWishlist: (_ authorName: String, _ bookTitle: String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text(bookTitle)
                        .font(EditorialSerif.displayMedium)
                    
                    Text(author)
                        .bodyStyle()
                }
                
                Spacer()
                
                Button {
                    addBookToWishlist(bookTitle, author)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.PRIMARY_BRAND)
                        .accessibilityLabel("Add to wishlist")
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom)
            
            Text(description)
                .metadataStyle()
            
            HStack(alignment: .top) {
                Color.secondaryBrand
                    .frame(width: 1)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack(spacing: 10) {
                        Image(systemName: "eyes")
                        Text("Why we recommend this")
                            .font(EditorialSerif.headlineMedium)
                    }
                    
                    Text(whyRecommend)
                        .metadataStyle()
                }
                .padding()
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.secondaryBrand.opacity(0.1))
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.SURFACE_LOW)
        }
    }
}
