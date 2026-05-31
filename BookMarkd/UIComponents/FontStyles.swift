//
//  FontStyles.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 31/05/26.
//

import SwiftUI

// MARK: - Typography Modifiers
extension View {

    /// Book titles in library, detail view, search results
    /// Font: Newsreader SemiBold 34px · Color: onSurface · Tracking: -0.5
    func bookTitleStyle() -> some View {
        self
            .font(EditorialSerif.displayLarge)
            .foregroundStyle(Color.onSurface)
            .tracking(-0.5)
    }

    /// Section headers: "Currently Reading", "Recent Finish", "Your Wishlist"
    /// Font: Newsreader SemiBold 28px · Color: onSurface
    func sectionTitleStyle() -> some View {
        self
            .font(EditorialSerif.headlineLarge)
            .foregroundStyle(Color.onSurface)
    }

    /// User-written quotes and notes in NotesAndQuotesView
    /// Font: Newsreader Regular 20px · Color: onSurface · LineSpacing: 6
    func quoteStyle() -> some View {
        self
            .font(EditorialSerif.quote)
            .foregroundStyle(Color.onSurface)
            .lineSpacing(6)
    }

    /// Author names, dates, page counts, rating numbers, badge labels
    /// Font: Manrope Medium 13px · Color: secondaryText
    func metadataStyle() -> some View {
        self
            .font(EditorialSans.label)
            .foregroundStyle(Color.secondaryText)
    }

    /// Body text: book descriptions, review content
    /// Font: Manrope Regular 17px · Color: onSurface
    func bodyStyle() -> some View {
        self
            .font(EditorialSans.bodyLarge)
            .foregroundStyle(Color.onSurface)
    }

    /// Primary button label
    /// Font: Manrope SemiBold 15px · Color: white (on primaryBrand background)
    func primaryButtonLabelStyle() -> some View {
        self
            .font(EditorialSans.button)
            .foregroundStyle(Color.SURFACE_LOWEST)
    }

    /// "Editorial" tertiary button: Archive, Show all, Write a Review
    /// Font: Newsreader SemiBold 17px · Color: tertiaryBrand · Underline
    func editorialButtonStyle() -> some View {
        self
            .font(Font.custom("Newsreader-SemiBold", size: 17))
            .foregroundStyle(Color.tertiaryBrand)
            .underline(true, color: Color.tertiaryBrand.opacity(0.5))
    }

    /// Empty state poetry lines
    /// Font: Newsreader Regular 24px · Color: onSurface · Center aligned
    func emptyStatePoetryStyle() -> some View {
        self
            .font(EditorialSerif.emptyState)
            .foregroundStyle(Color.onSurface)
            .multilineTextAlignment(.center)
    }
}

// MARK: - Layout Modifiers

extension View {

    /// Standard editorial horizontal + vertical padding
    /// Horizontal: 32px (2rem), top: 56px for first section, subsequent: 12px
    func editorialPagePadding() -> some View {
        self.padding(.horizontal, 32)
    }

    /// Tonal section separator — use INSTEAD of drawing a line
    /// Adds vertical breathing room; shifts bg context via ZStack or container
    func sectionSpacing() -> some View {
        self.padding(.bottom, 44)
    }
}

// MARK: - Card Styles
struct EditorialCardStyle: ViewModifier {
    var level: Int = 1  // 1 = surfaceLow, 2 = surfaceLowest

    func body(content: Content) -> some View {
        content
            .background(level == 2 ? Color.surfaceLowest : Color.surfaceLow)
            .clipShape(RoundedRectangle(cornerRadius: level == 2 ? 24 : 16))
    }
}

extension View {
    /// Level 1 card — for section containers
    func editorialCard() -> some View {
        self.modifier(EditorialCardStyle(level: 1))
    }

    /// Level 2 card — for feature cards, individual book rows
    func editorialFeatureCard() -> some View {
        self.modifier(EditorialCardStyle(level: 2))
    }
}

// MARK: - Signature: Quote Block
struct QuoteBlockStyle: ViewModifier {
    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            Color.tertiaryBrand
                .frame(width: 4)
                .clipShape(Capsule())
            content
                .quoteStyle()
                .padding(16)
        }
        .background(Color.tertiaryContainer.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension View {
    /// The signature Quote Block from the design spec
    /// tertiaryBrand 4px left accent + tertiaryContainer bg + Newsreader quote font
    func quoteBlockStyle() -> some View {
        self.modifier(QuoteBlockStyle())
    }
}
