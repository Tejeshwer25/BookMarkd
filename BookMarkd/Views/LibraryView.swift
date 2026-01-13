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
    @State private var currentlyReadingBooks: [String] = []
    @State private var finishedBooks: [String] = [""]
    
    var body: some View {
        if self.currentlyReadingBooks.isEmpty && self.finishedBooks.isEmpty {
            self.noBookView
                .sheet(isPresented: $showAddBookScreen) {
                    AddBookView()
                        .presentationDetents([.large])
                }
        } else {
            self.libraryViewWithBooks
                .searchable(text: $searchText, prompt: "Search for a book")
                .onChange(of: searchText) { _, newValue in
                    withAnimation {
                        self.isSearching = !newValue.isEmpty
                    }
                }
                .toolbar {
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
    
    var libraryViewWithBooks: some View {
        ScrollView {
            if !isSearching {
                VStack(alignment: .leading, spacing: 50) {
                    VStack(alignment: .leading) {
                        Text("Currently Reading")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        if self.currentlyReadingBooks.isEmpty {
                            self.emptyCurrentlyReadingView
                        } else {
                            ScrollView(.horizontal) {
                                HStack(spacing: 50) {
                                    self.currentlyReadingBookView
                                }
                            }
                            .scrollIndicators(.hidden)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Finished Books")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        if self.finishedBooks.isEmpty {
                            self.emptyFinishedBooksView
                        } else {
                            VStack(spacing: 30) {
                                HStack(spacing: 25) {
                                    self.finishedBooksView
                                    self.finishedBooksView
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .navigationTitle("Library")
            } else {
                SearchView(results: .constant([searchText]))
            }
        }
    }
    
    var finishedBooksView: some View {
        Button {
            self.router.pushScreen(.bookDetails(id: .init()))
        } label: {
            VStack {
                BookImage(bookImageURL: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400", imageFrame: (width: 150, height: 200))
                
                VStack(alignment: .leading, spacing: 7) {
                    Text("The Midnight Library")
                        .font(.headline)
                    Text("Matt Haig")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            if index > 3 {
                                Image(systemName: "star")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                            } else {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 12, height: 12)
                            }
                        }
                    }
                    
                    Text("Dec 20, 2025")
                        .font(.caption2)
                        .fontWeight(.light)
                        .foregroundStyle(Color.secondary)
                }
                .padding(.horizontal)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
    
    var currentlyReadingBookView: some View {
        Button {
            self.router.pushScreen(.bookDetails(id: .init()))
        } label: {
            HStack(alignment: .top) {
                BookImage(bookImageURL: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400", imageFrame: (width: 125, height: 175))
                
                VStack(alignment: .leading) {
                    Text("The Midnight Library")
                        .font(.headline)
                    Text("Matt Haig")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical)
            }
            .frame(maxWidth: 275)
        }
        .buttonStyle(.plain)
    }
    
    var emptyCurrentlyReadingView: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .center) {
                Text("Nothing on your desk right now")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("When you begin a book it will wait for you here")
                    .padding(.top, 1)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                Button {
                    self.showAddBookScreen = true
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add a Book")
                    }
                    .padding()
                    .background {
                        Capsule()
                            .foregroundStyle(.gray)
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(.black)
            }
            .padding(.horizontal, 25)
            .padding(.vertical)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.gray.opacity(0.2))
            }
            .padding()
            
            
            Spacer()
        }
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
            
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    LibraryView()
}
