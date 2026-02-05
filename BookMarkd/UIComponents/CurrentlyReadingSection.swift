//
//  CurrentlyReadingSection.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/02/26.
//

import SwiftUI

struct CurrentlyReadingSection: View {
    let currentlyReadingBookList: [BookModel]
    let store: AppStore
    let viewModel: LibraryViewModel
    let onBookCardTap: (String) -> Void
    
    var body: some View {
        Section("Currently Reading") {
            if self.viewModel.checkForViewToBeShown(store) == .noCurrentlyReadingBook {
                self.emptyCurrentlyReadingView
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(currentlyReadingBookList) { book in
                            Button {
                                onBookCardTap(book.id)
                            } label: {
                                HStack(alignment: .top) {
                                    BookImage(bookImageURL: book.coverImageURL ?? "",
                                              imageFrame: (width: 125, height: 175))
                                    
                                    VStack(alignment: .leading) {
                                        Text(book.title)
                                            .font(.headline)
                                        
                                        Text(book.authorName.first ?? "Unknown Author")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .padding(.top, 1)
                                    }
                                    .padding(.vertical)
                                    
                                    Spacer()
                                }
                                .frame(width: 300)
                            }
                            .padding(.trailing, 20)
                            .buttonStyle(.plain)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .listRowBackground(Color.clear)
    }
    
    var emptyCurrentlyReadingView: some View {
        VStack(alignment: .center) {
            Text("Nothing on your desk right now")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("When you begin a book it will wait for you here")
                .padding(.top, 1)
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .padding(25)
    }
}

#Preview {
    CurrentlyReadingSection(currentlyReadingBookList: [],
                            store: .init(),
                            viewModel: LibraryViewModel()) { id in
        print(id)
    }
}
