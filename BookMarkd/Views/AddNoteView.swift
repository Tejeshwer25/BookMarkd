//
//  AddNoteView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/01/26.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var quotesModel: QuotesModel
    
    @State private var errorOccurred: Bool = false
    @State private var errorMessage: String = ""
    
    let inEditMode: Bool = false
    let book: BookModel?
    
    let bookRepository: BookRepository
    
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
            .background(.primaryBrand.opacity(0.5))
            
            HStack {
                Button {
                    
                } label: {
                    Text("Quote")
                        .foregroundStyle(.primaryBrand)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 15)
                        .background {
                            Capsule()
                                .stroke(Color.primaryBrand)
                        }
                }
                
                Button {
                    
                } label: {
                    Text("Reflection")
                        .foregroundStyle(.primaryBrand)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 15)
                        .background {
                            Capsule()
                                .stroke(Color.primaryBrand)
                        }
                }
                
                Button {
                    
                } label: {
                    Text("Scene")
                        .foregroundStyle(.primaryBrand)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 15)
                        .background {
                            Capsule()
                                .stroke(Color.primaryBrand)
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
        .alert("Error", isPresented: $errorOccurred, actions: {}, message: { Text(errorMessage) })
        .frame(maxWidth: .infinity)
        .navigationTitle("Add Note or Quote")
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
                    let quote = self.quotesModel.text.trimmingCharacters(in: .whitespacesAndNewlines)
                    if quote.isEmpty {
                        dismiss()
                        return
                    }
                    
                    if !self.inEditMode {
                        HapticManager.shared.trigger(.success)
                        withAnimation {
                            do {
                                try self.bookRepository.addQuote(self.quotesModel,
                                                                 toBook: self.book?.id ?? "")
                            } catch {
                                self.errorOccurred = true
                                
                                guard let err = error as? PersistenceError else {
                                    self.errorMessage = error.localizedDescription
                                    return
                                }
                                
                                self.errorMessage = err.errrorDescription ?? error.localizedDescription
                            }
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
