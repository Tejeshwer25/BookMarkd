//
//  RoundedBoxContainer.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 01/03/26.
//

import SwiftUI

struct RoundedBoxContainer: View {
    var shouldShowTag: Bool = false
    let icon: String
    let title: String
    let value: String
    var tagText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 18, height: 20)
                
                Spacer()
                
                if shouldShowTag {
                    Text(tagText)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background {
                            Capsule()
                                .foregroundStyle(Color.yellow.opacity(0.3))
                        }
                }
            }
            
            Text(title)
                .font(.headline)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .fontDesign(.serif)
        .padding(21)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                .fill(Color.blue.opacity(0.1))
        }
    }
}

#Preview {
    RoundedBoxContainer(icon: "calendar", title: "Books Finished", value: "4")
}
