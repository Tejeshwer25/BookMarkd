//
//  BeginSearchView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 22/03/26.
//

import SwiftUI

struct BeginSearchView: View {
    let imageName: String
    let headlineText: String
    let subheadlineText: String
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 75, height: 75)
                .padding()
            
            Text(headlineText)
                .font(.title2)
                .fontDesign(.serif)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
                .lineLimit(2)
            
            Text(subheadlineText)
                .font(.subheadline)
                .fontDesign(.serif)
                .multilineTextAlignment(.center)
                .italic()
        }
        .opacity(1)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    BeginSearchView(imageName: "book",
                    headlineText: "Test",
                    subheadlineText: "Test2")
}
