//
//  BookProgressBar.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 01/03/26.
//

import SwiftUI

struct BookProgressBar: View {
    let genreName: String
    let numberOfBooks: Int
    let totalBooks: Int
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("\(genreName)")
                
                Spacer()
                
                Text("\(numberOfBooks) Books")
                    .font(.caption)
            }
            
            ProgressView(value: Double(numberOfBooks)/Double(totalBooks))
                .progressViewStyle(.linear)
        }
        .fontDesign(.serif)
    }
}

#Preview {
    BookProgressBar(
        genreName: "Science Fiction",
        numberOfBooks: 10,
        totalBooks: 15
    )
}
