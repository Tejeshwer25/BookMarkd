//
//  FinishBookView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/01/26.
//

import SwiftUI
import SwiftData

struct FinishBookView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel: FinishBookViewModel
    
    let bookID: String
    
    init(bookID: String, bookRepository: any BookRepository) {
        self.bookID = bookID
        self._viewModel = StateObject(
            wrappedValue: FinishBookViewModel(bookRepository: bookRepository)
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack(alignment: .bottom) {
                    BookImage(bookImageURL: self.viewModel.book?.coverImageURL,
                              bookImageData: self.viewModel.book?.coverImageData,
                              bookTitle: self.viewModel.book?.title ?? "",
                              imageFrame: (.infinity, 500))
                        .clipped()
                    
                    LinearGradient(
                        colors: [Color.clear, Color.SURFACE_LOWEST, Color.SURFACE_LOW, Color.SURFACE],
                        startPoint: .top, endPoint: .bottom
                    )
                    .frame(height: 160)
                    
                    VStack(alignment: .leading) {
                        Text(viewModel.book?.title ?? "")
                            .font(EditorialSerif.displayMedium)
                            .foregroundStyle(Color.ON_SURFACE)
                            .tracking(-0.5)
                        
                        Text(viewModel.book?.authorName.joined(separator: ", ") ?? "")
                            .metadataStyle()
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack(spacing: 30) {
                    VStack(spacing: 5) {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.bottom)
                        
                        Text("Time to finish")
                            .metadataStyle()
                        
                        Text("\(self.viewModel.getNumberOfDaysTakenToComplete())")
                            .font(EditorialSerif.headlineLarge)
                            .foregroundStyle(Color.ON_SURFACE)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.neutralButton.opacity(0.15))
                    }
                    .editorialFeatureCard()
                    
                    VStack(spacing: 5) {
                        Image(systemName: "text.quote")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.bottom)
                        
                        Text("Quotes Captured")
                            .metadataStyle()
                        
                        Text("\(self.viewModel.book?.quotes.count ?? 0)")
                            .font(EditorialSerif.headlineLarge)
                            .foregroundStyle(Color.ON_SURFACE)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.neutralButton.opacity(0.15))
                    }
                    .editorialFeatureCard()
                }
                
                VStack(spacing: 10) {
                    Text("How was the journey?")
                        .font(.headline)
                    
                    HStack {
                        ForEach(1..<6) { index in
                            Button {
                                HapticManager.shared.trigger(.impactLight)
                                withAnimation {
                                    self.viewModel.updateBookRating(to: index,
                                                                    bookID: self.bookID)
                                }
                            } label: {
                                if (self.viewModel.book?.rating ?? 0) >= index {
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundStyle(Color.secondaryBrand)
                                } else {
                                    Image(systemName: "star")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.vertical)
                
                if self.viewModel.doesBookContainReview == false {
                    Button {
                        self.viewModel.openAddReviewSheet.toggle()
                    } label: {
                        Text("Write a Review")
                            .font(Font.custom("Newsreader-SemiBold", size: 17))
                            .foregroundStyle(Color.TERTIARY_BRAND)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Color.TERTIARY_CONTAINER)
                            }
                    }
                    .buttonStyle(.plain)
                }
                
                HStack {
                    Button {
                        HapticManager.shared.trigger(.success)
                    } label: {
                        HStack(alignment: .center) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.neutralButton.opacity(0.2))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray.opacity(0.5))
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        HapticManager.shared.trigger(.impactMedium)
                        self.viewModel.markBookAsRead(bookID: self.bookID)
                        self.router.popToRoot()
                    } label: {
                        HStack(alignment: .center) {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Done")
                        }
                        .primaryButtonLabelStyle()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.PRIMARY_BRAND)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle("Reading Milestone")
        .onAppear {
            self.viewModel.loadBook(self.bookID)
        }
        .alert("Error", isPresented: $viewModel.errorOccurred) {} message: {
            Text(self.viewModel.errorMessage ?? "Unknown error occured")
        }
        .sheet(isPresented: $viewModel.openAddReviewSheet) {
            NavigationStack {
                BookReviewSheet() { review in
                    self.viewModel.saveBookReview(bookReview: review)
                }
            }
        }
    }
}
