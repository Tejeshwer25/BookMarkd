//
//  SettingsView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 08/01/26.
//

import SwiftUI

struct SettingsView: View {
    @State private var settingsOptionList = ["Genre preferences", "Appearance", "About"]
    
    var body: some View {
        List(settingsOptionList, id: \.self, rowContent: { setting in
            Text(setting)
        })
        .padding(.top)
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
