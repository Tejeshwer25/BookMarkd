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
            
            Tab("Settings", systemImage: "gearshape") {
                NavigationStackContainer(router: router) {
                    SettingsView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
