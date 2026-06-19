//
//  StarRatingView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 19/06/26.
//

import SwiftUI

struct StarRatingView: View {
    let rating: Int
    var isInteractive = false
    var starSize: CGFloat = 20
    var onRatingChanged: ((Int) -> Void)? = nil

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1..<6) { index in
                let filled = rating >= index
                Image(systemName: filled ? "star.fill" : "star")
                    .resizable()
                    .frame(width: starSize, height: starSize)
                    .foregroundStyle(filled ? Color.TERTIARY_BRAND : Color.SECONDARY_TEXT)
                    .onTapGesture {
                        guard isInteractive else { return }
                        HapticManager.shared.trigger(.impactLight)
                        onRatingChanged?(index)
                    }
            }
        }
    }
}
