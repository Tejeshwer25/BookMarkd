//
//  FinishBookView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/01/26.
//

import SwiftUI

struct FinishBookView: View {
    @EnvironmentObject private var router: Router
    
    let bookID: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("You've completed a new chapter")
                
                BookImage(bookImageURL: "", imageFrame: (150, 190))
                
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
                }
                .padding(.top, 25)
                
                VStack {
                    Text("How was the journey?")
                        .font(.headline)
                    
                    Image(systemName: "star")
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
                        Text("Share")
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
                        
                    } label: {
                        Text("Done")
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
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .navigationTitle("Reading Milestone")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FinishBookView(bookID: "")
    }
}
