//
//  AppColors.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 21/03/26.
//

import SwiftUI

// MARK: - The Editorial Monograph Palette
// Light mode: warm parchment surfaces, charcoal ink, sage + gold brand
// Dark mode:  #1a1a17 base ("midnight page"), #e8e6de ink (warm off-white)
// Rule: never use Color.black or #000000 — always onSurface
// Rule: never use fontDesign(.serif) — always Font.custom("Newsreader-...")

extension Color {

    // MARK: — Surfaces (tonal layering: 0 → 1 → 2)
    /// Level 0 — Primary page background. xcassets: #fbf9f4 / #1a1a17
    static let SURFACE = Color("Surface")

    /// Level 1 — Section containers, pressed states. xcassets: #f0ede5 / #252520
    static let SURFACE_LOW = Color("SurfaceLow")

    /// Level 2 — Feature cards, elevated cells. xcassets: #ffffff / #2e2e28
    static let SURFACE_LOWEST = Color("SurfaceLowest")

    // MARK: — Text
    /// Primary text. xcassets: #31332c / #e8e6de  — "Charcoal Ink"
    static let ON_SURFACE = Color("OnSurface")

    /// Secondary / metadata text. xcassets: #6b6d63 / #9b9990
    static let SECONDARY_TEXT = Color("SecondaryText")

    // MARK: — Brand
    /// CTA buttons, active states, progress fills — "Sage Leaf"
    /// xcassets: #506354 / #7a9e8b
    static let PRIMARY_BRAND = Color("PrimaryBrand")

    /// Header gradient top, genre chip fills — "Sage Container"
    /// xcassets: #c8dcd0 / #2a4035
    static let PRIMARY_CONTAINER = Color("PrimaryContainer")

    /// Stars, quote accent bar, favorites, completion — "Old Paper Gold"
    /// xcassets: #785a1a / #c99a40
    static let TERTIARY_BRAND = Color("TertiaryBrand")

    /// Quote block fill, gold-tinted chip bg — "Gold Container"
    /// xcassets: #e8d9b0 / #3d2e0a
    static let TERTIARY_CONTAINER = Color("TertiaryContainer")

    // MARK: — Outline / Borders
    /// "Ghost Border" — only for input fields and accessibility-critical edges
    /// NOT for sectioning or card separation
    static let ghostBorder = Color.ON_SURFACE.opacity(0.12)

    /// Ambient shadow for FABs only (never on list rows)
    /// Usage: .shadow(color: .ambientShadow, radius: 32, y: 8)
    static let ambientShadow = Color.ON_SURFACE.opacity(0.06)

    // MARK: — Semantic
    static let ratingsStar = Color.TERTIARY_BRAND
    static let secondaryBrand = Color.PRIMARY_BRAND   // consolidate — use primaryBrand
    static let neutralButton = Color.SURFACE_LOW       // map old token to new system

    // MARK: — Tag Colors (deterministic, not random)
    /// Use index % allAppColors.count — never randomElement()
    static let allAppColors: [Color] = [
        Color.PRIMARY_BRAND,
        Color.TERTIARY_BRAND,
        Color("TagBlue"),    // xcassets: #3d6b85 / #5a9cbf
        Color("TagPurple"),  // xcassets: #6b4d7a / #9b7aad
        Color("TagRose"),    // xcassets: #8c4a5a / #c47a8a
    ]
}
