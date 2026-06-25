//
//  BookDetailBody.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 19/06/26.
//

import SwiftUI

struct BookDetailBody: View {
    @ObservedObject var viewModel: BookDetailViewModel
    let bookId: String
    
    var body: some View {
        VStack {
            if self.viewModel.book?.readState == .reading {
                NotesAndQuotesView(notesList: self.viewModel.book?.quotes ?? [],
                                   showAddNoteButton: true,
                                   bookReadingStatus: self.viewModel.book?.readState,
                                   book: self.viewModel.book) { quoteAction, quote in
                    self.viewModel.performQuoteAction(quoteAction, on: quote)
                }
            } else if self.viewModel.book?.readState == .wishlist {
                VStack(alignment: .leading, spacing: 25) {
                    if let bookDescription = self.viewModel.bookDetails?.description {
                        BookDescriptionView(description: bookDescription)
                    }
                    
                    if let characters = self.viewModel.bookDetails?.characters,
                       characters.isEmpty == false {
                        BookCharacterView(characters: characters)
                    }
                    
                    if let genres = self.viewModel.bookDetails?.genre?.sorted(by: { $0.count < $1.count }) {
                        BookTagsView(genres: genres, showAllTags: $viewModel.showAllTags)
                    }
                }
                .padding()
            } else if self.viewModel.book?.readState == .read {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Book Review")
                        .sectionTitleStyle()
                    
                    Text(self.viewModel.book?.bookReview ?? "")
                        .bodyStyle()
                }
                .padding()
                
                if self.viewModel.book?.quotes.isEmpty == false {
                    NotesAndQuotesView(notesList:  self.viewModel.book?.quotes ?? [],
                                       showAddNoteButton: false,
                                       bookReadingStatus: try? viewModel.fetchBookDataFromRepo(bookId)?.readState,
                                       book: self.viewModel.book) { quoteAction, quote in
                        self.viewModel.performQuoteAction(quoteAction, on: quote)
                    }
                }
            }
        }
    }
}
