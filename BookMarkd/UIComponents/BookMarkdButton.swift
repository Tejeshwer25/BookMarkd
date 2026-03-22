//
//  BookMarkdButton.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 22/03/26.
//

import SwiftUI

enum ImagePlacementInButton {
    case left, right
}

struct RoundedRectangleButton: View {
    let buttonText: String
    let imageName: String?
    var imagePlacement: ImagePlacementInButton = .left
    var buttonFillColor: Color = Color.accentColor
    var buttonTextColor: Color = Color.neutral
    var buttonBorderColor: Color? = nil
    var cornerRadius: CGFloat = 5
    var buttonPaddingHorizontal: CGFloat = 18
    var buttonPaddingVertical: CGFloat = 18
    let action: () -> Void
    
    init(buttonText: String,
         imageName: String?,
         imagePlacement: ImagePlacementInButton = .left,
         buttonFillColor: Color = .accentColor,
         buttonTextColor: Color = .neutral,
         buttonBorderColor: Color? = nil,
         cornerRadius: CGFloat = 5,
         buttonPaddingHorizontal: CGFloat = 18,
         buttonPaddingVertical: CGFloat = 18,
         action: @escaping () -> Void) {
        
        self.buttonText = buttonText
        self.imageName = imageName
        self.imagePlacement = imagePlacement
        self.buttonFillColor = buttonFillColor
        self.buttonTextColor = buttonTextColor
        self.buttonBorderColor = buttonBorderColor
        self.cornerRadius = cornerRadius
        self.buttonPaddingHorizontal = buttonPaddingHorizontal
        self.buttonPaddingVertical = buttonPaddingVertical
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 5) {
                if let imageName = imageName, imagePlacement == .left {
                    Image(systemName: imageName)
                }
                
                Text(buttonText)
                
                if let imageName = imageName, imagePlacement == .right {
                    Image(systemName: imageName)
                }
            }
            .font(.Editorial.button)
            .frame(maxWidth: .infinity)
            .foregroundStyle(buttonTextColor)
            .padding(.horizontal, buttonPaddingHorizontal)
            .padding(.vertical, buttonPaddingVertical)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(buttonFillColor)
                    .stroke(buttonBorderColor != nil ? buttonBorderColor! : .clear)
            }
        }
    }
}

#Preview {
    RoundedRectangleButton(buttonText: "hi",
                           imageName: "book",
                           buttonFillColor: .red,
                           buttonTextColor: .green) {
        
    }
}
