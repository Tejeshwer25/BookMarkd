//
//  NotesAndQuotesView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 07/02/26.
//

import SwiftUI

struct NotesAndQuotesView: View {
    @EnvironmentObject private var router: Router
    
    let notesList: [QuotesModel]
    let showAddNoteButton: Bool
    let bookReadingStatus: BookReadingState?
    let book: BookModel?
    var quoteAction: ((QuoteAction, QuotesModel?) -> Void)? = nil
    @State private var currentNoteIndex: Int = 1
    @State private var currentQuoteId: QuotesModel.ID?
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderComponent(headerTitle: "Notes & Quotes \( self.notesList.count > 0 ? "(\(currentNoteIndex) / \(self.notesList.count))" : "")",
                                   textFont: EditorialSerif.headlineLarge) {
                if showAddNoteButton {
                    Button {
                        self.router.pushScreen(.addNotes(quoteModel: nil, inEditMode: .create, book: book))
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.white)
                            .accessibilityLabel("Add Note")
                    }
                }
            }
            .padding(.bottom)
            
            if !self.notesList.isEmpty {
                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing: 10) {
                        ForEach(self.notesList, id: \.self.id) { quote in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(quote.noteType.rawValue.capitalized)
                                        .metadataStyle()
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 7)
                                        .background {
                                            Capsule()
                                                .stroke(quote.noteType.fillColor)
                                        }
                                    
                                    Spacer()
                                    
                                    Button {
                                        self.quoteAction?(.share, quote)
                                    } label: {
                                        Image(systemName: "square.and.arrow.up")
                                            .resizable()
                                            .frame(width: 15, height: 20)
                                            .accessibilityLabel("Share Note")
                                            .foregroundStyle(Color.SECONDARY_TEXT)
                                    }
                                    .buttonStyle(.plain)
                                }
                                
                                Text(quote.text)
                                    .frame(maxHeight: .infinity, alignment: .top)
                                    .padding(.top)
                                    .onTapGesture {
                                        self.router.pushScreen(.addNotes(quoteModel: quote, inEditMode: nil, book: book))
                                    }
                            }
                            .frame(width: 300, height: 350, alignment: .leading)
                            .padding()
                            .quoteBlockStyle()
                            .contextMenu {
                                Button(action: {
                                    self.quoteAction?(.share, quote)
                                }) {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }
                                
                                if bookReadingStatus == .reading {
                                    Button(action: {
                                        self.router.pushScreen(.addNotes(quoteModel: quote, inEditMode: .edit, book: book))
                                    }) {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    
                                    Button(role: .destructive, action: {
                                        self.quoteAction?(.delete, quote)
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                            .id(quote.id)
                        }
                    }
                    .scrollTargetLayout() // Align content to the view
                }
                .scrollIndicators(.hidden)
                .contentMargins(5, for: .scrollContent) // Add padding
                .scrollTargetBehavior(.viewAligned) // Align content behavior
                .scrollPosition(id: $currentQuoteId)
                .onChange(of: currentQuoteId) { _, newValue in
                    if let newValue,
                       let idx = self.notesList.firstIndex(where: { $0.id == newValue }) {
                        self.currentNoteIndex = idx + 1
                    }
                }
            } else {
                EmptyStateView(imageName: "note.text",
                               imageSize: (width: 75, height: 75),
                               titleText: "No notes/quotes added for this book yet.")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            }
        }
        .padding()
    }
}
