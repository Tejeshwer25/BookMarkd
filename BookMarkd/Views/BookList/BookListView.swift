//
//  BookListView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 09/04/26.
//

import SwiftUI

struct BookListView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel: BookListViewModel
    
    init(bookRepository: any BookRepository,
         bookList: [BookModel]) {
        self._viewModel = StateObject(wrappedValue: BookListViewModel(bookRepository: bookRepository,
                                                                      bookList: bookList))
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 25) {
                ForEach(viewModel.bookList) { book in
                    Button {
                        router.pushScreen(.bookDetails(id: book.id))
                    } label: {
                        VStack(alignment: .leading) {
                            BookImage(bookImageURL: book.coverImageURL ?? "",
                                      bookImageData: book.coverImageData,
                                      bookTitle: book.title,
                                      imageFrame: (150, 200))
                            
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(EditorialSerif.headlineMedium)
                                    .foregroundStyle(Color.ON_SURFACE)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(book.authorName.joined(separator: ", "))
                                    .font(EditorialSans.label)
                                    .foregroundStyle(Color.SECONDARY_TEXT)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(width: 150, alignment: .leading)
                        }
                        .frame(width: 150, alignment: .leading)
                        .contextMenu {
                            if book.readState == .wishlist {
                                Button(role: .destructive) {
                                    viewModel.removeBookConfirmation(book: book.id)
                                } label: {
                                    Label("Remove", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top)
        }
        .navigationTitle(viewModel.bookList.first?.readState.rawValue.capitalized ?? "Books")
        .navigationBarTitleDisplayMode(.inline)
        .alert(viewModel.alertInfo.title, isPresented: $viewModel.alertInfo.isVisible) {
            ForEach(viewModel.alertInfo.actions) { action in
                Button(action.title, role: buttonRole(for: action.role)) {
                    withAnimation {
                        viewModel.handleAlertAction(action.id, bookID: viewModel.bookToDelete ?? "")
                    }
                }
            }
        } message: {
            Text(viewModel.alertInfo.message)
        }
    }
    
    private func buttonRole(for role: AlertActionRole?) -> ButtonRole? {
        switch role {
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        case nil:
            return nil
        }
    }

}
