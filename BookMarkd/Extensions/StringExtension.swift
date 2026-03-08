//
//  StringExtension.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 08/03/26.
//

import SwiftUI

extension String {
    var stableColor: Color {
        var hash = 0
        for char in self.unicodeScalars { hash = 31 &* hash &+ Int(char.value) }
        let hue = Double(abs(hash) % 360) / 360.0
        return Color(hue: hue, saturation: 0.4, brightness: 0.85)
    }
}
