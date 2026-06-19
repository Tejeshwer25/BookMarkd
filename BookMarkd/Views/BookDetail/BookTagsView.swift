//
//  BookTagsView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 19/06/26.
//

import SwiftUI

struct BookTagsView: View {
    let genres: [String]
    @Binding var showAllTags: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tags")
                .sectionTitleStyle()
            
            FlowLayout(items: genres, spacing: 10, rowSpacing: 8, maxRows: showAllTags ? nil : 2) { index, tag in
                Text(tag)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 7)
                    .background {
                        Capsule()
                            .fill((Color.allAppColors[index % Color.allAppColors.count]).opacity(0.15))
                    }
            }
            
            if genres.count > 0 {
                Button {
                    withAnimation(.snappy) { showAllTags.toggle() }
                } label: {
                    HStack {
                        showAllTags ? Image(systemName: "chevron.up") : Image(systemName: "chevron.down")
                        showAllTags ? Text("Show Less") : Text("Show All")
                    }
                }
                .font(.callout)
                .foregroundStyle(Color.ON_SURFACE)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.neutralButton.opacity(0.15))
                }
            }
        }
    }
}
