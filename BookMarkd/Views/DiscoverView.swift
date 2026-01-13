//
//  DiscoverView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 08/01/26.
//

import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject private var router: Router
    
    @State private var books = ["Book 1", "Book 2", "Book 3"]
    
    var body: some View {
        List(books, id: \.self, rowContent: { book in
            Button {
                self.router.pushScreen(.bookDetails(id: .init()))
            } label: {
                HorizontalBookPreview(bookName: book, descriptionLineLimit: 3)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .buttonStyle(.plain)
            
        })
        .navigationTitle("Discover")
        .navigationSubtitle("Books you might enjoy")
    }
}

#Preview {
    DiscoverView()
}
