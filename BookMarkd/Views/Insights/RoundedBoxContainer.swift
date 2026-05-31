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
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 18, height: 20)
                    .foregroundStyle(iconColor)
                
                Spacer()
                
                if shouldShowTag {
                    Text(tagText)
                        .font(EditorialSans.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background {
                            Capsule()
                                .foregroundStyle(Color.secondaryBrand.opacity(0.3))
                        }
                }
            }
            
            Text(title)
                .metadataStyle()
            
            Text(value)
                .quoteStyle()
        }
        .padding(21)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                .fill(Color.neutralButton.opacity(0.2))
        }
    }
}
