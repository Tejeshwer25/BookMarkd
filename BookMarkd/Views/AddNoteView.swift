//
//  AddNoteView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/01/26.
//

import SwiftUI

struct AddNoteView: View {
    @EnvironmentObject private var store: StorageManageer
    @Environment(\.dismiss) var dismiss
    
    @Bindable var quotesModel: QuotesModel
    
    let inEditMode: Bool = false
    let book: BookModel?
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(book?.title ?? "")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text(book?.authorName.joined(separator: ", ") ?? "")
                }
                .padding()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.tertiary)
            
            HStack {
                Button {
                    
                } label: {
                    Text("Quote")
                        .foregroundStyle(.black)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 15)
                        .background {
                            Capsule()
                                .foregroundStyle(Color.gray)
                        }
                }
                
                Button {
                    
                } label: {
                    Text("Reflection")
                        .foregroundStyle(.black)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 15)
                        .background {
                            Capsule()
                                .foregroundStyle(Color.gray)
                        }
                }
                
                Button {
                    
                } label: {
                    Text("Scene")
                        .foregroundStyle(.black)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 15)
                        .background {
                            Capsule()
                                .foregroundStyle(Color.gray)
                        }
                }
                
                Spacer()
            }
            .padding()
            
            TextEditor(text: $quotesModel.text)
                .padding()
                .overlay {
                    if self.quotesModel.text.isEmpty {
                        VStack {
                            HStack {
                                Text("Enter a meaningful quote")
                                Spacer()
                            }
                            Spacer()
                        }
                        .padding(25)
                    }
                }
            
            Spacer()
            
            HStack {
                Text("Page Number (optional)")
                
                Spacer()
                    .frame(maxWidth: .infinity)
                
                TextField("100", text: Binding(
                    get: { String(self.quotesModel.pageNumber ?? 0) },
                    set: { newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        if let intVal = Int(filtered) {
                            self.quotesModel.pageNumber = intVal
                        } else {
                            self.quotesModel.pageNumber = nil
                        }
                    }
                ))
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(width: 75)
                .padding(7)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .navigationTitle("Add Note or Quote")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    if !self.inEditMode {
                        HapticManager.shared.trigger(.success)
                        withAnimation {
                            self.store.addQuoteToBook(id: self.book?.id ?? "",
                                                      quote: self.quotesModel)
                        }
                    }
                    dismiss()
                } label: {
                    Text(self.inEditMode ? "Edit" : "Save")
                }
            }
        }
    }
}

#Preview {
    //AddNoteView(book: .init(id: "", title: "", authorName: [], readState: .read))
}
