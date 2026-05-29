//
//  AppFonts.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 21/03/26.
//

import SwiftUI

enum EditorialSerif {
    static let displayLarge = Font.custom("Newsreader9pt-SemiBold", size: 34, relativeTo: .largeTitle)
    static let displayMedium = Font.custom("Newsreader9pt-SemiBold", size: 28, relativeTo: .title)
    static let headlineLarge = Font.custom("Newsreader9pt-SemiBold", size: 22, relativeTo: .title2)
    static let headlineMedium = Font.custom("Newsreader9pt-Regular", size: 18, relativeTo: .title3)
    static let quote = Font.custom("Newsreader9pt-Regular", size: 20, relativeTo: .title3)
    static let displayHero   = Font.custom("Newsreader9pt-SemiBold", size: 56)
    static let emptyState    = Font.custom("Newsreader9pt-Regular",  size: 24, relativeTo: .title2)
}

enum EditorialSans {
    static let bodyLarge = Font.custom("Manrope-Regular", size: 17, relativeTo: .body)
    static let bodyMedium = Font.custom("Manrope-Regular", size: 15, relativeTo: .subheadline)
    static let label = Font.custom("Manrope-Medium", size: 13, relativeTo: .caption)
    static let caption = Font.custom("Manrope-Regular", size: 12, relativeTo: .caption2)
    static let button = Font.custom("Manrope-SemiBold", size: 15, relativeTo: .headline)
}

extension Font {
    struct Editorial {
        static let bookTitle = EditorialSerif.displayLarge
        static let sectionTitle = EditorialSerif.displayMedium
        static let quote = EditorialSerif.quote
        
        static let body = EditorialSans.bodyLarge
        static let metadata = EditorialSans.label
        static let caption = EditorialSans.caption
        static let button = EditorialSans.button
    }
}
