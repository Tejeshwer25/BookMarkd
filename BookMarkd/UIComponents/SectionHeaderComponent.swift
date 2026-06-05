//
//  SectionHeaderComponent.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/06/26.
//

import SwiftUI

struct SectionHeaderComponent<Content: View>: View {
    let headerTitle: String
    var textFont: Font   = EditorialSerif.displayMedium
    var textColor: Color = .ON_SURFACE
    @ViewBuilder var rightView: () -> Content
    
    var body: some View {
        HStack {
            Text(headerTitle)
                .font(textFont)
                .foregroundStyle(textColor)
            
            Spacer()
            
            rightView()
        }
    }
}

extension SectionHeaderComponent where Content == EmptyView {
    init(
        headerTitle: String,
        textFont: Font   = EditorialSerif.displayMedium,
        textColor: Color = .ON_SURFACE
    ) {
        self.headerTitle = headerTitle
        self.textFont = textFont
        self.textColor = textColor
        self.rightView = { EmptyView() }
    }
}
