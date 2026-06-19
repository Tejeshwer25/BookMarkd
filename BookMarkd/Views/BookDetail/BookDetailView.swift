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
    
    init(bookId: String,
         bookRepository: any BookRepository,
         bookService: any BookService) {
        self._viewModel = StateObject(wrappedValue: BookDetailViewModel(bookRepository: bookRepository,
                                                                        bookService: bookService))
        self.bookId = bookId
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                BookHeaderView(book: viewModel.book) { action in
                    switch action {
                    case .markAsFinished:
                        self.router.pushScreen(.bookFinishScreen(id: self.bookId))
                    case .startReading:
                        try? self.viewModel.updateBookReadState(bookID: bookId)
                        self.router.popScreen()
                    }
                }
                
                BookDetailBody(viewModel: self.viewModel,
                               bookId: self.bookId)
            }
        }
        .navigationTitle("")
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        self.viewModel.handleTapOnRemoveMenuButton()
                    } label: {
                        Label("Remove from wishlist", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        })
        .sheet(isPresented: $viewModel.showAddNoteSheet) {
            NavigationStack {
                AddNoteView(bookRepository: viewModel.bookRepository,
                            router: router,
                            quotesModel: .init(id: .init(),
                                               noteType: .quote,
                                               text: "",
                                               date: Date()),
                            book: viewModel.book,)
            }
        }
        .sheet(item: $viewModel.noteToEdit) { quote in
            NavigationStack {
                AddNoteView(bookRepository: viewModel.bookRepository,
                            router: router,
                            quotesModel: quote,
                            book: self.viewModel.book)
            }
        }
        .sheet(item: $viewModel.noteToShare) { quote in
            NavigationStack {
                ShareQuoteView(book: viewModel.book, quote: quote)
            }
        }
        .onAppear {
            self.viewModel.book = try? viewModel.fetchBookDataFromRepo(bookId)
            if self.viewModel.book?.readState == .unread || self.viewModel.book?.readState == .wishlist {
                withAnimation {
                    self.viewModel.isPageLoading = true
                    self.viewModel.getBookDetails(self.bookId)
                }
            }
        }
        .overlay {
            if self.viewModel.isPageLoading {
                ZStack {
                    Color.SURFACE_LOWEST.opacity(0.5).ignoresSafeArea()
                    ProgressView()
                }
            }
        }
        .alert(self.viewModel.alertTitle, isPresented: $viewModel.shouldShowAlert) {
            // Alert Actions
            ForEach(viewModel.alertButtons, id: \.self) { button in
                Button(role: button == .delete ? .destructive : .cancel) {
                    viewModel.handleAlertAction(actionType: button)
                    if button == .delete {
                        self.router.popScreen()
                    }
                } label: {
                    Text(button.rawValue)
                }
            }
        } message: {
            Text(self.viewModel.alertMesssage)
        }
    }
    
    var tagsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tags")
                .sectionTitleStyle()

            // Demo tags (replace with your actual tags source when available)
            let tags = self.viewModel.bookDetails?.genre?.sorted { $0.count < $1.count } ?? []

            FlowLayout(items: tags, spacing: 10, rowSpacing: 8, maxRows: viewModel.showAllTags ? nil : 2) { index, tag in
                Text(tag)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 7)
                    .background {
                        Capsule()
                            .fill((Color.allAppColors[index % Color.allAppColors.count]).opacity(0.15))
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
                .foregroundStyle(Color.ON_SURFACE)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.neutralButton.opacity(0.15))
                }
            }
        }
    }
    
    var bookDescriptionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Description")
                .sectionTitleStyle()
            
            Text(self.viewModel.bookDetails?.description ?? "")
                .font(.callout)
        }
    }
    
    var bookCharactersView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Characters")
                .sectionTitleStyle()
            
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
}

