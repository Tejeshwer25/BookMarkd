//
//  BookWishlistView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/01/26.
//

import SwiftUI

struct BookWishlistView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var store: AppStore
    @StateObject private var viewModel = WishlishtViewModel()
    
    var body: some View {
        if self.viewModel.getWishListedBooks(store).isEmpty {
            self.noWishlistedBooksView
                .navigationTitle("Wishlist")
        } else {
            self.wishlistedBooksView
                .navigationTitle("Wishlist")
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
        List(self.viewModel.getWishListedBooks(store), id: \.self.id) { book in
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
