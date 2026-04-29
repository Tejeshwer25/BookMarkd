//
//  BookMarkdWidgetsBundle.swift
//  BookMarkdWidgets
//
//  Created by Tejeshwer Singh on 27/04/26.
//

import WidgetKit
import SwiftUI

@main
struct BookMarkdWidgetsBundle: WidgetBundle {
    var body: some Widget {
        BookMarkdWidgets()
        BookMarkdWidgetsControl()
        BookMarkdWidgetsLiveActivity()
    }
}
