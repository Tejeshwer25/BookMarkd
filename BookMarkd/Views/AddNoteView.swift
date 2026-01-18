//
//  AddNoteView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/01/26.
//

import SwiftUI

struct AddNoteView: View {
    @Environment(\.dismiss) var dismiss
    @State private var note: String = ""
    @State private var pageNumber: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("The Midnight Library")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("Matt Haig")
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
            
            TextEditor(text: $note)
                .padding()
                .overlay {
                    if note.isEmpty {
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
                
                TextField("100", text: $pageNumber)
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
                    dismiss()
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

#Preview {
    AddNoteView()
}
