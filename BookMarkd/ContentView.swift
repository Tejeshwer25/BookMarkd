//
//  ContentView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 27/12/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var router = Router()
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var storeManager: StorageManageer
    @Query private var preferences: [UserPreferenceModel]
    
    var body: some View {
        TabView {
            Tab("Library", systemImage: "books.vertical") {
                NavigationStackContainer(router: router) {
                    LibraryView()
                }
            }
            
            Tab("Discover", systemImage: "book") {
                NavigationStackContainer(router: router) {
                    DiscoverView()
                }
            }
            
            Tab("Insights", systemImage: "chart.xyaxis.line") {
                NavigationStackContainer(router: router) {
                    InsightsView()
                }
            }
            
            Tab("Settings", systemImage: "gearshape") {
                NavigationStackContainer(router: router) {
                    SettingsView()
                }
            }
        }
        .onAppear {
            self.storeManager.setContext(self.modelContext)
        }
        .task {
            self.setupUserPreferencesIfNeeded()
        }
    }
    
    /// Method to setup user preferences 
    private func setupUserPreferencesIfNeeded() {
        if let existing = preferences.first {
            storeManager.userPreferences = existing
        } else {
            let newPreferences = UserPreferenceModel(preferedGenres: [],
                                                     createdDate: .now)
            modelContext.insert(newPreferences)
            storeManager.userPreferences = newPreferences
        }
    }
}

#Preview {
    ContentView()
}
