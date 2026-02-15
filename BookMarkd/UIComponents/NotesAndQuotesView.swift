//
//  NotesAndQuotesView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 07/02/26.
//

import SwiftUI

struct NotesAndQuotesView: View {
    let notesList: [QuotesModel]
    let showAddNoteButton: Bool
    let bookReadingStatus: BookReadingState?
    var quoteAction: ((QuoteAction, QuotesModel?) -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Notes & Quotes")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                if showAddNoteButton {
                    Button {
                        self.quoteAction?(.add, nil)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.bottom)
            
            if !self.notesList.isEmpty {
                ForEach(self.notesList, id: \.self.id) { quote in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(quote.noteType.rawValue.capitalized)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 7)
                                .background {
                                    Capsule()
                                        .foregroundStyle(Color.red.opacity(0.3))
                                }
                            
                            Spacer()
                            
                            Button {
                                self.quoteAction?(.share, quote)
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .frame(width: 15, height: 20)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        Text(quote.text)
                            .padding(.top, 7)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.gray.opacity(0.2))
                    }
                    .contextMenu {
                        Button(action: {
                            self.quoteAction?(.share, quote)
                        }) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        
                        if bookReadingStatus == .reading {
                            Button(action: {
                                self.quoteAction?(.edit, quote)
                            }) {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Button(role: .destructive, action: {
                                
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            } else {
                VStack {
                    Image(systemName: "note.text")
                        .resizable()
                        .frame(width: 75, height: 75)
                    Text("No notes/quotes added for this book yet.")
                        .padding(.top, 25)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            }
        }
        .padding()
    }
}

#Preview {
    NotesAndQuotesView(notesList: [
        .init(id: .init(), noteType: .note, text: "hfuiwhf hfuwe uih uuew u", date: .init())
    ], showAddNoteButton: false, bookReadingStatus: .reading)
}
