//
//  LibraryView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 27/12/25.
//

import SwiftUI
import _SwiftData_SwiftUI

struct LibraryView: View {
    @Query private var books: [BookModel]
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel: LibraryViewModel
    
    let bookRepository: any BookRepository
    
    init(bookRepository: any BookRepository) {
        self._viewModel = StateObject(wrappedValue: LibraryViewModel(bookRepository: bookRepository))
        self.bookRepository = bookRepository
    }
    
    var body: some View {
        let viewToBeShown = self.viewModel.checkForViewToBeShown(books)
        let currentlyReadingBookList = self.viewModel.getBookListFor(readingState: .reading, from: books)
        let finishedBooksList = self.viewModel.getBookListFor(readingState: .read, from: self.books)
        let wishlistedBooks = self.viewModel.getBookListFor(readingState: .wishlist, from: self.books)
        
        if viewToBeShown == .noBooksPresent {
            self.noBookView
        } else {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(self.books.count) books | \(finishedBooksList.count) finished this year")
//                        Spacer()
//                        Text("4 Day Streak")
//                            .padding(.horizontal, 12)
//                            .padding(.vertical, 6)
//                            .background {
//                                Capsule()
//                                    .stroke(Color.yellow, lineWidth: 1)
//                                    .fill(.yellow.opacity(0.2))
//                            }
                    }
                    .fontDesign(.serif)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                    
                    VStack {}
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .padding(.bottom)
                    
                    CurrentlyReadingSection(currentlyReadingBookList: currentlyReadingBookList,
                                            viewModel: viewModel) {
                        self.router.pushScreen(.bookDetails(id: $0))
                    }
                                            .padding()
                    
                    FinishedBooksSection(viewModel: self.viewModel,
                                         finishedBookList: finishedBooksList) {
                        self.router.pushScreen(.bookDetails(id: $0))
                    }
                                         .padding()
                    
                    WishlistSection(viewModel: self.viewModel,
                                    wishlishtedBooks: wishlistedBooks) {
                        self.router.pushScreen(.bookDetails(id: $0))
                    }
                                    .padding()
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Library")
            .onChange(of: self.viewModel.searchText) { _, newValue in
                withAnimation {
                    self.viewModel.isSearching = !newValue.isEmpty
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.router.pushScreen(.addBookScreen)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    var noBookView: some View {
        VStack(alignment: .center) {
            Image(systemName: "books.vertical.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("Your reading archive is empty")
                .padding(.top, 25)
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Start with one book. \nThe rest will gather itself")
                .multilineTextAlignment(.center)
                .font(.body)
            
            Button {
                self.router.pushScreen(.addBookScreen)
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Add a Book")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.gray.opacity(0.2))
                }
            }
            .padding()
            .buttonStyle(.plain)
            
        }
        .frame(maxWidth: .infinity)
    }
}
