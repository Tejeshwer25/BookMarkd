//
//  HapticsManager.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/01/26.
//

import UIKit

enum AppHaptic {
    case selection
    case impactLight
    case impactMedium
    case success
    case error
}

final class HapticManager {
    static let shared = HapticManager()

    private let selection = UISelectionFeedbackGenerator()
    private let light = UIImpactFeedbackGenerator(style: .light)
    private let medium = UIImpactFeedbackGenerator(style: .medium)
    private let notification = UINotificationFeedbackGenerator()

    private init() {}

    func trigger(_ type: AppHaptic) {
        switch type {
        case .selection:
            selection.selectionChanged()

        case .impactLight:
            light.impactOccurred()

        case .impactMedium:
            medium.impactOccurred()

        case .success:
            notification.notificationOccurred(.success)

        case .error:
            notification.notificationOccurred(.error)
        }
    }
}

