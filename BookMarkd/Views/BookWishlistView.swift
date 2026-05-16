//
//  BookWishlistView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/01/26.
//

import SwiftUI
import SwiftData

struct BookWishlistView: View {
    @Query(filter: #Predicate<BookModel> { $0.readStateRaw == "wishlist" })
    private var wishlistBooks: [BookModel]
    @Query private var allBooks: [BookModel]
    
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel = WishlishtViewModel()
    
    var body: some View {
        if self.wishlistBooks.isEmpty {
            self.noWishlistedBooksView
                .navigationTitle("Wishlist")
                .onAppear {
                    print(wishlistBooks)
                    print(allBooks.map { $0.readStateRaw })
                }
        } else {
            self.wishlistedBooksView
                .navigationTitle("Wishlist")
                .onAppear {
                    print(wishlistBooks)
                }
        }
    }
    
    var noWishlistedBooksView: some View {
        VStack(alignment: .center) {
            Image(systemName: "books.vertical.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            
            Text("No Wishlisted Books")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Add books to wishlist from home screen to view them here")
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    var wishlistedBooksView: some View {
        List(self.wishlistBooks, id: \.self.id) { book in
            Button {
                self.router.pushScreen(.bookDetails(id: book.id))
            } label: {
                HorizontalBookPreview(book: book, descriptionLineLimit: 3)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    NavigationStack {
        BookWishlistView()
    }
}
