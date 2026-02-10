//
//  WishlishtViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 01/02/26.
//

import Combine

class WishlishtViewModel: ObservableObject {
    func getWishListedBooks(_ store: StorageManageer) -> [BookModel] {
        return store.getBookList().filter { $0.readState == .wishlist }
    }
}
