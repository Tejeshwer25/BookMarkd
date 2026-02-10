//
//  BookDetailView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/01/26.
//

import SwiftUI
import UIKit

struct BookDetailView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var store: StorageManageer
    
    @State private var showAddNoteSheet: Bool = false
    @State private var book: BookModel?
    @State private var bookDetails: BookDetailDataModel? = nil
    @State private var isPageLoading: Bool = false
    @State private var showAllTags: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMesssage: String = ""
    @State private var shouldShowAlert: Bool = false
    
    var bookId: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                bookInfoView
                
                if self.book?.readState == .reading {
                    NotesAndQuotesView(notesList: self.store.getBookWith(id: self.bookId)?.quotes ?? [], showAddNoteButton: true) {
                        self.showAddNoteSheet.toggle()
                    }
                } else if self.book?.readState == .wishlist {
                    VStack(alignment: .leading, spacing: 25) {
                        bookDescriptionView
                        
                        if self.bookDetails?.characters?.isEmpty == false {
                            bookCharactersView
                        }
                        
                        tagsView
                    }
                    .padding()
                } else if self.book?.readState == .read {
                    NotesAndQuotesView(notesList: self.store.getBookWith(id: self.bookId)?.quotes ?? [], showAddNoteButton: false)
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddNoteSheet) {
            NavigationStack {
                AddNoteView(book: self.book)
            }
        }
        .onAppear {
            self.book = store.getBookWith(id: self.bookId)
            if self.book?.readState == .unread || self.book?.readState == .wishlist {
                withAnimation {
                    self.isPageLoading = true
                    self.getBookDetails(self.bookId)
                }
            }
        }
        .overlay {
            if self.isPageLoading {
                ProgressView()
            }
        }
        .alert(self.alertTitle, isPresented: $shouldShowAlert) {} message: {
            Text(self.alertMesssage)
        }
    }
    
    var bookInfoView: some View {
        HStack(alignment: .top, spacing: 25) {
            BookImage(bookImageURL: self.book?.coverImageURL ?? "",
                      imageFrame: (width: 150, height: 200))
            
            VStack(alignment: .leading, spacing: 10) {
                Text(self.book?.title ?? "")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text(self.book?.authorName.first ?? "")
                
                if self.book?.readState == .reading {
                    Button("Mark as Finished") {
                        self.router.pushScreen(.bookFinishScreen(id: self.bookId))
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        Capsule()
                            .foregroundStyle(.primary)
                    }
                } else if self.book?.readState == .wishlist {
                    Button("Start Reading") {
                        self.store.updateBookReadState(to: .reading, for: self.bookId)
                        self.router.popScreen()
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        Capsule()
                            .foregroundStyle(.primary)
                    }
                    .padding(.top)
                } else if self.book?.readState == .read {
                    HStack {
                        ForEach(1..<6) { index in
                            if (self.book?.rating ?? 0) >= index {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(.yellow)
                            } else {
                                Image(systemName: "star")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    var tagsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tags")
                .font(.title3)
                .fontWeight(.bold)

            // Demo tags (replace with your actual tags source when available)
            let tags = self.bookDetails?.genre?.sorted { $0.count < $1.count } ?? []

            FlowLayout(items: tags, spacing: 10, rowSpacing: 8, maxRows: showAllTags ? nil : 2) { tag in
                Text(tag)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 7)
                    .background {
                        Capsule()
                            .fill(Color(
                                red: Double.random(in: 0...1),
                                green: Double.random(in: 0...1),
                                blue: Double.random(in: 0...1)
                            ).opacity(0.15))
                    }
                    .overlay {
                        Capsule()
                            .stroke(Color(
                                red: Double.random(in: 0...1),
                                green: Double.random(in: 0...1),
                                blue: Double.random(in: 0...1)
                            ).opacity(0.5), lineWidth: 1)
                    }
            }

            if tags.count > 0 {
                Button {
                    withAnimation(.snappy) { showAllTags.toggle() }
                } label: {
                    HStack {
                        showAllTags ? Image(systemName: "chevron.up") : Image(systemName: "chevron.down")
                        showAllTags ? Text("Show Less") : Text("Show All")
                    }
                }
                .font(.callout)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.gray.opacity(0.15))
                }
            }
        }
    }
    
    var bookDescriptionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Description")
                .font(.title3)
                .fontWeight(.bold)
            
            Text(self.bookDetails?.description ?? "")
                .font(.callout)
        }
    }
    
    var bookCharactersView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Characters")
                .font(.title3)
                .fontWeight(.bold)
            
            ScrollView(.horizontal) {
                HStack(spacing: 25) {
                    ForEach(self.bookDetails?.characters ?? [], id: \.self) { character in
                        VStack(alignment: .center, spacing: 15) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 75, height: 75)
                            Text(character)
                        }
                    }
                }
            }
            .padding(.vertical, 20)
            .scrollIndicators(.hidden)
        }
    }
    
    func getBookDetails(_ bookID: String) {
        if let url = URL(string: "https://openlibrary.org/") {
            let service = BookServiceUtility(api: .init(baseURL: url))
            Task {
                do {
                    let book = try await service.getBookDetails(bookID)
                    self.bookDetails = book
                    withAnimation {
                        self.isPageLoading = false
                    }
                } catch {
                    withAnimation {
                        self.isPageLoading = false
                        self.shouldShowAlert = true
                    }
                    
                    self.alertTitle = "Error"
                    self.alertMesssage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    var appstore = StorageManageer()
    
    NavigationStack {
        BookDetailView(bookId: "works/OL82563W")
            .environmentObject(appstore)
    }
}

