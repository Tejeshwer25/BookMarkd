//
//  RecommendedBooksView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/02/26.
//

import SwiftUI

struct RecommendedBooksView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "moon.stars.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
                .overlay {
                    Circle()
                        .stroke(Color.secondaryBrand)
                }
            
            Text("Discovery Complete")
                .font(.title)
                .fontDesign(.serif)
            
            Text("We handpicked these literary treasures based on your reading habits.")
                .multilineTextAlignment(.center)
                .fontDesign(.serif)
        }
    }
}
