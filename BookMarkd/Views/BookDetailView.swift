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
    @StateObject private var viewModel: BookDetailViewModel
    
    var bookId: String
    @State var imageToShare: UIImage?
    
    init(bookId: String, bookRepository: any BookRepository) {
        self._viewModel = StateObject(wrappedValue: BookDetailViewModel(bookRepository: bookRepository))
        self.bookId = bookId
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                bookInfoView
                
                if self.viewModel.book?.readState == .reading {
                    let notesList = try? viewModel.bookRepository.book(id: bookId)?.quotes
                    let readState = try? viewModel.bookRepository.book(id: bookId)?.readState
                    
                    NotesAndQuotesView(notesList: notesList ?? [],
                                       showAddNoteButton: true,
                                       bookReadingStatus: readState) { quoteAction, quote in
                        self.viewModel.performQuoteAction(quoteAction, on: quote)
                    }
                } else if self.viewModel.book?.readState == .wishlist {
                    VStack(alignment: .leading, spacing: 25) {
                        bookDescriptionView
                        
                        if self.viewModel.bookDetails?.characters?.isEmpty == false {
                            bookCharactersView
                        }
                        
                        tagsView
                    }
                    .padding()
                } else if self.viewModel.book?.readState == .read {
                    let bookReview = try? self.viewModel.bookRepository.book(id: bookId)?.bookReview
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Book Review")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Text(bookReview ?? "")
                            .font(.callout)
                    }
                    .padding()
                    
                    let notesList = try! viewModel.bookRepository.book(id: bookId)?.quotes ?? []
                    if !notesList.isEmpty {
                        NotesAndQuotesView(notesList: try! viewModel.bookRepository.book(id: bookId)?.quotes ?? [],
                                           showAddNoteButton: false,
                                           bookReadingStatus: try? viewModel.bookRepository.book(id: bookId)?.readState) { quoteAction, quote in
                            self.viewModel.performQuoteAction(quoteAction, on: quote)
                        }
                    }
                }
            }
        }
        .navigationTitle("")
        .sheet(isPresented: $viewModel.showAddNoteSheet) {
            NavigationStack {
                AddNoteView(quotesModel: .init(id: .init(),
                                               noteType: .quote,
                                               text: "",
                                               date: Date()),
                            book: viewModel.book,
                            bookRepository: viewModel.bookRepository, router: router)
            }
        }
        .sheet(item: $viewModel.noteToEdit) { quote in
            NavigationStack {
                AddNoteView(quotesModel: quote,
                            book: self.viewModel.book,
                            bookRepository: viewModel.bookRepository, router: router)
            }
        }
        .sheet(item: $viewModel.noteToShare, onDismiss: {
            if let imageToShare {
                self.shareImage(imageToShare)
            }
        }) { quote in
            NavigationStack {
                ShareQuoteView(book: viewModel.book, quote: quote, onDismiss: { image in
                    self.imageToShare = image
                })
            }
        }
        .onAppear {
            self.viewModel.book = try? viewModel.bookRepository.book(id: bookId)
            if self.viewModel.book?.readState == .unread || self.viewModel.book?.readState == .wishlist {
                withAnimation {
                    self.viewModel.isPageLoading = true
                    self.viewModel.getBookDetails(self.bookId)
                }
            }
        }
        .overlay {
            if self.viewModel.isPageLoading {
                ProgressView()
            }
        }
        .alert(self.viewModel.alertTitle, isPresented: $viewModel.shouldShowAlert) {} message: {
            Text(self.viewModel.alertMesssage)
        }
    }
    
    var bookInfoView: some View {
        HStack(alignment: .top, spacing: 25) {
            BookImage(bookImageURL: self.viewModel.book?.coverImageURL,
                      bookImageData: self.viewModel.book?.coverImageData,
                      bookTitle: self.viewModel.book?.title ?? "",
                      imageFrame: (width: 150, height: 200))
            
            VStack(alignment: .leading, spacing: 10) {
                Text(self.viewModel.book?.title ?? "")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text(self.viewModel.book?.authorName.first ?? "")
                
                if self.viewModel.book?.readState == .reading {
                    Button("Mark as Finished") {
                        HapticManager.shared.trigger(.impactMedium)
                        self.router.pushScreen(.bookFinishScreen(id: self.bookId))
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        Capsule()
                            .foregroundStyle(.accent)
                    }
                } else if self.viewModel.book?.readState == .wishlist {
                    Button("Start Reading") {
                        try? self.viewModel.bookRepository.updateReadState(.reading, for: bookId)
                        self.router.popScreen()
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        Capsule()
                            .foregroundStyle(.accent)
                    }
                    .padding(.top)
                } else if self.viewModel.book?.readState == .read {
                    HStack {
                        ForEach(1..<6) { index in
                            if (self.viewModel.book?.rating ?? 0) >= index {
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundStyle(.secondaryBrand)
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
            let tags = self.viewModel.bookDetails?.genre?.sorted { $0.count < $1.count } ?? []

            FlowLayout(items: tags, spacing: 10, rowSpacing: 8, maxRows: viewModel.showAllTags ? nil : 2) { tag in
                Text(tag)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 7)
                    .background {
                        Capsule()
                            .fill((Color.allAppColors.randomElement() ?? .secondaryBrand).opacity(0.15))
                    }
                    .overlay {
                        Capsule()
                            .stroke((Color.allAppColors.randomElement() ?? .secondaryBrand).opacity(0.5), lineWidth: 1)
                    }
            }

            if tags.count > 0 {
                Button {
                    withAnimation(.snappy) { viewModel.showAllTags.toggle() }
                } label: {
                    HStack {
                        viewModel.showAllTags ? Image(systemName: "chevron.up") : Image(systemName: "chevron.down")
                        viewModel.showAllTags ? Text("Show Less") : Text("Show All")
                    }
                }
                .font(.callout)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.neutralButton.opacity(0.15))
                }
            }
        }
    }
    
    var bookDescriptionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Description")
                .font(.title3)
                .fontWeight(.bold)
            
            Text(self.viewModel.bookDetails?.description ?? "")
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
                    ForEach(self.viewModel.bookDetails?.characters ?? [], id: \.self) { character in
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
    
    func shareImage(_ image: UIImage) {
        let controller = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )

        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first?
            .rootViewController?
            .present(controller, animated: true)
    }
}

