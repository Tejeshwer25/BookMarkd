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
    
    var body: some View {
        ScrollView {
            if !isSearching {
                VStack(alignment: .leading, spacing: 50) {
                    VStack(alignment: .leading) {
                        Text("Currently Reading")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 50) {
                                currentlyReadingBookView
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Finished Books")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 30) {
                            HStack(spacing: 25) {
                                finishedBooksView
                                finishedBooksView
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
        .searchable(text: $searchText, prompt: "Seach and Add to library")
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
            AddBookView(bookTitle: self.$bookTitle)
                .presentationDetents([.medium, .large])
        }
    }
    
    var finishedBooksView: some View {
        Button {
            self.router.pushScreen(.bookDetails(id: .init()))
        } label: {
            VStack {
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400")) { image in
                    image
                        .resizable()
                        .frame(width: 150, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } placeholder: {
                    Text("Loading Image...")
                }
                
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
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400")) { image in
                    image
                        .resizable()
                        .frame(width: 125, height: 175)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } placeholder: {
                    Text("Loading Image...")
                }
                
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
}

#Preview {
    LibraryView()
}
