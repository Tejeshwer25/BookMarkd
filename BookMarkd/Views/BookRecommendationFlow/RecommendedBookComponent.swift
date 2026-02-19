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
                        .fontDesign(.serif)
                        .font(.title2)
                    
                    Text(author)
                        .font(.callout)
                        .fontDesign(.serif)
                        .italic()
                }
                
                Spacer()
                
                Button {
                    addBookToWishlist(bookTitle, author)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom)
            
            Text(description)
                .fontDesign(.serif)
                .font(.subheadline)
            
            HStack(alignment: .top) {
                Color.brown
                    .frame(width: 1)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack(spacing: 10) {
                        Image(systemName: "eyes")
                        Text("Why we recommend this")
                    }
                    
                    Text(whyRecommend)
                }
                .font(.caption)
                .fontDesign(.serif)
                .padding()
            }
            .fixedSize(horizontal: false, vertical: true)
            .background(.brown.opacity(0.3))
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray.opacity(0.3))
        }
    }
}

#Preview {
    RecommendedBookComponent(bookTitle: "",
                             author: "",
                             description: "",
                             whyRecommend: "") { authorName, bookTitle in
        
    }
}
