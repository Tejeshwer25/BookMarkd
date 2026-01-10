//
//  Item.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 27/12/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
