//
//  SettingsView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 08/01/26.
//

import SwiftUI

enum SettingsOptionList: String, CaseIterable {
    case genrePreferences = "Genre preferences"
    case appearance = "Appearance"
    case about = "About"
}

struct SettingsView: View {
    @EnvironmentObject private var router: Router
    
    var body: some View {
        List {
            ForEach(SettingsOptionList.allCases, id: \.self) { setting in
                Button {
                    navigateToScreen(setting)
                } label: {
                    HStack {
                        Text(setting.rawValue)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                .buttonStyle(.plain)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Settings")
    }
    
    func navigateToScreen(_ screenName: SettingsOptionList) {
        switch screenName {
        case .genrePreferences:
            withAnimation {
                self.router.pushScreen(.genrePreferenceScreen)
            }
        default: break
        }
    }
}
