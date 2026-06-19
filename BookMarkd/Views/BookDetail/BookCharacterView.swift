//
//  BookCharacterView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 19/06/26.
//

import SwiftUI

struct BookCharacterView: View {
    let characters: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Characters")
                .sectionTitleStyle()
            
            ScrollView(.horizontal) {
                HStack(spacing: 25) {
                    ForEach(characters, id: \.self) { character in
                        VStack(alignment: .center, spacing: 15) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 75, height: 75)
                            Text(character)
                        }
                    }
                }
            }
            .padding(.vertical, 20)
            .scrollIndicators(.hidden)
        }
    }
}
