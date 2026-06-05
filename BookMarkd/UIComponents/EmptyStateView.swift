//
//  EmptyStateView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/06/26.
//

import SwiftUI

struct EmptyStateView<Content: View>: View {
    let imageName: String
    let imageSize: (width: CGFloat, height: CGFloat)
    var imageColor: Color = Color.PRIMARY_BRAND
    
    let titleText: String
    var titleTextFont: Font = EditorialSerif.emptyState
    var titleTextColor: Color = Color.ON_SURFACE
    
    var subtitleText: String? = nil
    var subtitleTextColor: Color = Color.SECONDARY_TEXT
    var subtitleTextFont: Font = EditorialSans.bodyMedium
    
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Image(systemName: imageName)
                .resizable()
                .frame(width: imageSize.width, height: imageSize.height)
                .padding(.bottom, 10)
                .foregroundStyle(imageColor)
                
            Text(titleText)
                .font(titleTextFont)
                .foregroundStyle(titleTextColor)
                .multilineTextAlignment(.center)
            
            if let subtitleText {
                Text(subtitleText)
                    .font(subtitleTextFont)
                    .foregroundStyle(subtitleTextColor)
                    .multilineTextAlignment(.center)
            }
            
            content()
        }
    }
}

extension EmptyStateView where Content == EmptyView {
    init(imageName: String,
         imageSize: (width: CGFloat, height: CGFloat),
         imageColor: Color        = .PRIMARY_BRAND,
         titleText: String,
         titleTextFont: Font      = EditorialSerif.emptyState,
         titleTextColor: Color    = .ON_SURFACE,
         subtitleText: String?    = nil,
         subtitleTextColor: Color = .SECONDARY_TEXT,
         subtitleTextFont: Font   = EditorialSans.bodyMedium) {
        self.imageName = imageName
        self.imageSize = imageSize
        self.imageColor = imageColor
        self.titleText = titleText
        self.titleTextFont = titleTextFont
        self.titleTextColor = titleTextColor
        self.subtitleText = subtitleText
        self.subtitleTextColor = subtitleTextColor
        self.subtitleTextFont = subtitleTextFont
        self.content = { EmptyView() }
    }
}
