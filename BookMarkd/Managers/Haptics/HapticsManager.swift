//
//  HapticsManager.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/01/26.
//

import Foundation
import UIKit

class HapticsManager {
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    private init() {
        self.impactGenerator.prepare()
    }
    
    func generateFeedback() {
        impactGenerator.impactOccurred()
        impactGenerator.prepare()
    }
    
    func generateNotificationFeedback(style: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(style)
    }
}

