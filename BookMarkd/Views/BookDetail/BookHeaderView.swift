//
//  BookHeaderView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 19/06/26.
//

import SwiftUI

enum BookDetailHeaderButtonAction {
    case markAsFinished
    case startReading
}

struct BookHeaderView: View {
    let book: BookModel?
    let handleButtonTap: ((BookDetailHeaderButtonAction) -> Void)
    
    var body: some View {
        HStack(alignment: .top, spacing: 25) {
            BookImage(bookImageURL: book?.coverImageURL,
                      bookImageData: book?.coverImageData,
                      bookTitle: book?.title ?? "",
                      imageFrame: (width: 150, height: 200))
            
            VStack(alignment: .leading, spacing: 10) {
                Text(book?.title ?? "")
                    .bookTitleStyle()
                
                Text(book?.authorName.first ?? "")
                    .metadataStyle()
                
                if book?.readState == .reading {
                    // Buttons when book is in Currently Reading section
                    Button {
                        HapticManager.shared.trigger(.impactMedium)
                        handleButtonTap(.markAsFinished)
                    } label: {
                        Text("Mark as Finished")
                            .font(EditorialSans.button)
                            .foregroundStyle(Color.SURFACE)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        Capsule()
                            .foregroundStyle(Color.PRIMARY_BRAND)
                    }
                } else if book?.readState == .wishlist {
                    // Button when book is in Wishlist section
                    VStack {
                        Button {
                            handleButtonTap(.startReading)
                        } label: {
                            Text("Start Reading")
                                .primaryButtonLabelStyle()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            Capsule()
                                .foregroundStyle(Color.PRIMARY_BRAND)
                        }
                        .padding(.top)
                    }
                } else if book?.readState == .read {
                    StarRatingView(rating: book?.rating ?? 0)
                }
            }
        }
        .padding()
    }
}
