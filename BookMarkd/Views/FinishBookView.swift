//
//  FinishBookView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/01/26.
//

import SwiftUI

struct FinishBookView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var store: StorageManageer
    @StateObject private var viewModel = FinishBookViewModel()
    
    let bookID: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("You've completed a new chapter")
                
                BookImage(bookImageURL: self.viewModel.book?.coverImageURL ?? "",
                          imageFrame: (150, 190))
                
                HStack(spacing: 30) {
                    VStack(spacing: 10) {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.bottom)
                        
                        Text("Time to finish")
                        Text("12 Days")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.gray.opacity(0.15))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray.opacity(0.75))
                    }
                    
                    VStack(spacing: 10) {
                        Image(systemName: "text.quote")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.bottom)
                        
                        Text("Quotes Captured")
                        Text("\(self.viewModel.book?.quotes?.count ?? 0)")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.gray.opacity(0.15))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray.opacity(0.75))
                    }
                }
                .padding(.top, 25)
                
                VStack(spacing: 10) {
                    Text("How was the journey?")
                        .font(.headline)
                    
                    HStack {
                        ForEach(1..<6) { index in
                            Button {
                                withAnimation {
                                    self.viewModel.updateBookRating(to: index,
                                                                    bookID: self.bookID,
                                                                    self.store)
                                }
                            } label: {
                                if (self.viewModel.book?.rating ?? 0) >= index {
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(.yellow)
                                } else {
                                    Image(systemName: "star")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.vertical)
                
                Button {
                    
                } label: {
                    Text("Write a Review")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.blue)
                        }
                }
                .buttonStyle(.plain)
                
                HStack {
                    Button {
                        
                    } label: {
                        HStack(alignment: .center) {
                            Image(systemName: "square.and.arrow.up")
                            
                            Text("Share")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.gray.opacity(0.2))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray.opacity(0.5))
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        self.viewModel.markBookAsRead(bookID: self.bookID, store)
                        self.router.popToRoot()
                    } label: {
                        HStack(alignment: .center) {
                            Image(systemName: "checkmark.circle.fill")
                            
                            Text("Done")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.gray.opacity(0.2))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray.opacity(0.5))
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle("Reading Milestone")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.viewModel.getBook(with: self.bookID, from: self.store)
        }
    }
}

#Preview {
    NavigationStack {
        FinishBookView(bookID: "")
    }
}
