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
    @EnvironmentObject private var store: StorageManageer
    @StateObject private var viewModel: LibraryViewModel = LibraryViewModel()
    
    var body: some View {
        let viewToBeShown = self.viewModel.checkForViewToBeShown(books)
        let currentlyReadingBookList = self.viewModel.getBookListFor(readingState: .reading, from: books)
        let finishedBooksList = self.viewModel.getBookListFor(readingState: .read, from: self.books)
        
        if viewToBeShown == .noBooksPresent {
            self.noBookView
                .sheet(isPresented: $viewModel.showAddBookScreen) {
                    AddBookView(query: .constant(""))
                        .presentationDetents([.large])
                }
        } else {
            List {
                CurrentlyReadingSection(currentlyReadingBookList: currentlyReadingBookList,
                                        viewModel: viewModel) { self.router.pushScreen(.bookDetails(id: $0)) }
                
                FinishedBooksSection(viewModel: self.viewModel,
                                     finishedBookList: finishedBooksList) { self.router.pushScreen(.bookDetails(id: $0)) }
            }
            .navigationTitle("Library")
//            .searchable(text: $viewModel.searchText, prompt: "Search for a book")
            .onChange(of: self.viewModel.searchText) { _, newValue in
                withAnimation {
                    self.viewModel.isSearching = !newValue.isEmpty
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.router.pushScreen(.bookWishlistScreen)
                    } label: {
                        Image(systemName: "bookmark")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.viewModel.showAddBookScreen = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddBookScreen) {
                AddBookView(query: .constant(""))
                    .presentationDetents([.large])
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
                self.viewModel.showAddBookScreen = true
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
            
            Button {
                self.router.pushScreen(.bookWishlistScreen)
            } label: {
                HStack {
                    Image(systemName: "bookmark")
                    Text("View Wishlist")
                }
            }
            .padding()
            
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        LibraryView()
    }
}
