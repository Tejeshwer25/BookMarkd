//
//  BookDetailView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/01/26.
//

import SwiftUI

struct BookDetailView: View {
    @EnvironmentObject private var router: Router
    
    @State private var quotes: [String] = []
    @State private var showAddNoteSheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                bookInfoView
                
                if quotes.isEmpty {
                    noNotesView
                } else {
                    notesAndQuotesView
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddNoteSheet) {
            NavigationStack {
                AddNoteView()
            }
        }
    }
    
    var bookInfoView: some View {
        HStack(alignment: .top, spacing: 25) {
            BookImage(bookImageURL: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400", imageFrame: (width: 150, height: 200))
            
            VStack(alignment: .leading, spacing: 10) {
                Text("The Midnight Library")
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text("Matt Haig")
                
                Text("67% complete")
                
                ProgressView(value: 0.67)
                    .padding(.bottom, 25)
                
                Button("Mark as Finished") {
                    self.router.pushScreen(.bookFinishScreen(id: .init()))
                }
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    Capsule()
                        .foregroundStyle(.primary)
                }
            }
        }
        .padding()
    }
    
    var notesAndQuotesView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Notes & Quotes")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    self.showAddNoteSheet.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.white)
                }

            }
            
            ForEach(quotes, id: \.self) { quote in
                VStack {
                    Text("Quote")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 7)
                        .background {
                            Capsule()
                                .foregroundStyle(Color.red.opacity(0.3))
                        }
                    
                    Text(quote)
                        .padding(.top, 7)
                        .padding(.leading, -20)
                }
                .padding()
            }
        }
        .padding()
    }
    
    var noNotesView: some View {
        VStack {
            HStack {
                Text("Notes & Quotes")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    self.showAddNoteSheet.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.white)
                }
            }
            
            Text("No notes added for this book yet.")
                .padding(.top, 25)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    NavigationStack {
        BookDetailView()
    }
}
