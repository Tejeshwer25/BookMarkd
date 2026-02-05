//
//  FinishedBooksSection.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/02/26.
//

import SwiftUI

struct FinishedBooksSection: View {
    let viewModel: LibraryViewModel
    let store: AppStore
    let finishedBookList: [BookModel]
    let onBookComponentTap: (String) -> Void
    
    var body: some View {
        Section(self.viewModel.checkForViewToBeShown(store) == .noFinishedBook ? "" : "Books Read") {
            if self.viewModel.checkForViewToBeShown(store) == .noFinishedBook {
                self.emptyFinishedBooksView
            } else {
                ForEach(self.finishedBookList) { book in
                    Button {
                        self.onBookComponentTap(book.id)
                    } label: {
                        HorizontalBookPreview(book: BookModel(id: book.id,
                                                              title: book.title,
                                                              authorName: book.authorName,
                                                          readState: .read),
                                              descriptionLineLimit: 2)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .listRowBackground(Color.clear)
    }
    
    var emptyFinishedBooksView: some View {
        VStack(alignment: .center) {}
    }
}

#Preview {
    FinishedBooksSection(viewModel: .init(),
                         store: .init(),
                         finishedBookList: [],
                         onBookComponentTap: {print($0)})
}
