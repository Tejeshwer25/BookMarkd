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
                HStack(spacing: 10) {
                    AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400")) { image in
                        image
                            .resizable()
                            .frame(width: 100, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } placeholder: {
                        Text("Loading Image...")
                    }
                    
                    VStack(alignment: .leading) {
                        Text(book)
                            .font(.headline)
                        
                        Text("Author Name")
                            .font(.subheadline)
                        
                        Text("A large book description that will compell the user to buy that book, but its not some marketing gimmick.")
                            .padding(.top)
                            .font(.footnote)
                    }
                }
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
