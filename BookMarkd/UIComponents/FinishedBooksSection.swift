//
//  FinishedBooksSection.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/02/26.
//

import SwiftUI

struct FinishedBooksSection: View {
    let viewModel: LibraryViewModel
    let finishedBookList: [BookModel]
    let onBookComponentTap: (String) -> Void
    
    var body: some View {
        Section(self.finishedBookList.isEmpty ? "" : "Books Read") {
            if self.finishedBookList.isEmpty {
                self.emptyFinishedBooksView
            } else {
                ForEach(self.finishedBookList) { book in
                    Button {
                        self.onBookComponentTap(book.id)
                    } label: {
                        HorizontalBookPreview(book: book,
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
                         finishedBookList: [],
                         onBookComponentTap: {print($0)})
}
