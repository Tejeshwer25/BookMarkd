//
//  LibraryView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 27/12/25.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject private var router: Router
    
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @State private var showAddBookScreen: Bool = false
    @State private var bookTitle: String = ""
    @State private var currentlyReadingBooks: [BookModel] = []
    @State private var finishedBooks: [BookModel] = []
    
    var body: some View {
        if self.currentlyReadingBooks.isEmpty && self.finishedBooks.isEmpty {
            self.noBookView
                .sheet(isPresented: $showAddBookScreen) {
                    AddBookView()
                        .presentationDetents([.large])
                }
        } else {
            List {
                Section("Currently Reading") {
                    if self.currentlyReadingBooks.isEmpty {
                        self.emptyCurrentlyReadingView
                    } else {
                        ScrollView(.horizontal) {
                            HStack(spacing: 10) {
                                self.currentlyReadingBookView
                                self.currentlyReadingBookView
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                .listRowBackground(Color.clear)
                
                Section("Books Read") {
                    if self.finishedBooks.isEmpty == false {
                        self.finishedBooksView
                    } else {
                        self.emptyFinishedBooksView
                    }
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Library")
            .searchable(text: $searchText, prompt: "Search for a book")
            .onChange(of: searchText) { _, newValue in
                withAnimation {
                    self.isSearching = !newValue.isEmpty
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
                        self.showAddBookScreen = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddBookScreen) {
                AddBookView()
                    .presentationDetents([.large])
            }
        }
    }
    
    var finishedBooksView: some View {
        ForEach(1...5, id: \.self) { element in
            Button {
                self.router.pushScreen(.bookDetails(id: .init()))
            } label: {
                HorizontalBookPreview(book: .init(id: "", title: "Test Book", authorName: []),
                                      descriptionLineLimit: 2)
            }
            .buttonStyle(.plain)
        }
    }
    
    var currentlyReadingBookView: some View {
        Button {
            self.router.pushScreen(.bookDetails(id: .init()))
        } label: {
            HStack(alignment: .top) {
                BookImage(bookImageURL: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400",
                          imageFrame: (width: 125, height: 175))
                
                VStack(alignment: .leading) {
                    Text("The Midnight Library")
                        .font(.headline)
                    
                    Text("Matt Haig")
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
    
    var emptyFinishedBooksView: some View {
        VStack(alignment: .center) {
            Image(systemName: "books.vertical.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .opacity(0.3)
            
            Text("No stories closed yet")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.top)
            
            Text("When you finish a book it will settle here quietly")
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        
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
                self.showAddBookScreen = true
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
