//
//  BookReviewSheet.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 10/04/26.
//

import SwiftUI

struct BookReviewSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var reviewText: String = ""
    let onSaveReview: (String) -> Void
    
    var body: some View {
        VStack {
            TextEditor(text: $reviewText)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                }
        }
        .padding()
        .navigationTitle("Add book review")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        onSaveReview(reviewText)
                    } completion: {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
