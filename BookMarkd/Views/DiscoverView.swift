//
//  DiscoverView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 08/01/26.
//

import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject private var router: Router
    
    @State private var books: [BookModel] = []
    
    var body: some View {
        List(books, id: \.self.id) { book in
            Button {
                self.router.pushScreen(.bookDetails(id: .init()))
            } label: {
                HorizontalBookPreview(book: book, descriptionLineLimit: 3)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .buttonStyle(.plain)
            
        }
        .overlay {
            if books.isEmpty {
                VStack(alignment: .center) {
                    Spacer()
                    
                    Image(systemName: "moon.stars.fill")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .padding()
                    
                    Text("No recommendation available")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Try again later after choosing your genre's or starting a new book")
                        .multilineTextAlignment(.center)
                        .padding(.top, 1)
                    
                    Spacer()
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Discover")
        .navigationSubtitle("Books you might enjoy")
    }
}

#Preview {
    NavigationStack {
        DiscoverView()
    }
}
