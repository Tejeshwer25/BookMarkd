//
//  AddBookView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 11/01/26.
//

import SwiftUI
import _SwiftData_SwiftUI

struct AddBookView: View {
    let hapticsManager = HapticManager.shared
    @Binding var query: String
    @Query private var booksInLibrary: [BookModel]
    @StateObject private var viewModel: AddBookViewModel
    @EnvironmentObject private var router: Router
    
    let bookRepository: any BookRepository
    
    init(query: Binding<String>, bookRepository: any BookRepository) {
        self._query = query
        self.bookRepository = bookRepository
        
        if !query.wrappedValue.isEmpty {
            self._viewModel = StateObject(wrappedValue: AddBookViewModel(bookRepository: bookRepository, bookTitle: query.wrappedValue))
        } else {
            self._viewModel = StateObject(wrappedValue: AddBookViewModel(bookRepository: bookRepository))
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            AddBookHeaderSection(bookTitle: $viewModel.bookTitle, router: router)
            
            if self.viewModel.viewToShow == .searchResults {
                AddBookSearchResults(viewModel: viewModel)
            } else if self.viewModel.viewToShow == .beginSearch {
                Spacer()
                BeginSearchView(imageName: "book.circle",
                                headlineText: "Begin your search to \nadd to your library",
                                subheadlineText: "Your personal collection of forgotten scrolls and future adventures awaits within the midnight shadows.")
            } else if self.viewModel.viewToShow == .loading {
                ScrollView {
                    self.loadingView
                }
            } else {
                Text("Error Occured")
            }
            
            
            Spacer()
        }
        .navigationTitle("Add to wishlist")
        .navigationSubtitle("Curate your next reading adventure")
        .navigationBarTitleDisplayMode(.large)
        .padding()
        .onChange(of: self.viewModel.bookTitle) { _ , newValue in
            self.viewModel.searchBook(bookName: newValue, booksInLibrary: self.booksInLibrary)
        }
        .alert("Error", isPresented: $viewModel.errorOccurred) {} message: {
            Text(self.viewModel.errorMessage ?? "")
        }
    }
    
    var loadingView: some View {
        VStack {
            Text("Consulting The Archives...")
                .fontDesign(.serif)
                .font(.title3)
            
            ForEach(0..<3) { _ in
                HStack(alignment: .top, spacing: 15) {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 100, height: 150)
                        .foregroundStyle(LinearGradient(colors: [.indigo.opacity(0.15), .brown.opacity(0.15)],
                                                        startPoint: .leading,
                                                        endPoint: .trailing))
                    
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 200, height: 25)
                            .foregroundStyle(LinearGradient(colors: [.indigo.opacity(0.15), .brown.opacity(0.15)],
                                                            startPoint: .leading,
                                                            endPoint: .trailing))
                        
                        RoundedRectangle(cornerRadius: 8)
                            .frame(maxWidth: 150, maxHeight: 25)
                            .foregroundStyle(LinearGradient(colors: [.indigo.opacity(0.15), .brown.opacity(0.15)],
                                                            startPoint: .leading,
                                                            endPoint: .trailing))
                        
                        HStack(spacing: 10) {
                            Capsule()
                                .frame(maxWidth: 75, maxHeight: 25)
                                .foregroundStyle(LinearGradient(colors: [.indigo.opacity(0.15), .brown.opacity(0.15)],
                                                                startPoint: .leading,
                                                                endPoint: .trailing))
                            
                            Capsule()
                                .frame(maxWidth: 75, maxHeight: 25)
                                .foregroundStyle(LinearGradient(colors: [.indigo.opacity(0.15), .brown.opacity(0.15)],
                                                                startPoint: .leading,
                                                                endPoint: .trailing))
                        }
                        .padding(.vertical)
                        
                    }
                    .padding(.vertical)
                }
                .padding(.vertical, 5)
            }
        }
    }
}
