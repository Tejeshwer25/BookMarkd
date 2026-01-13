//
//  AddBookView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 11/01/26.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var bookTitle: String = ""
    @State private var books: [String] = ["Test", "Another"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Add Book")
                .font(.title)
                .fontWeight(.bold)
            
            Divider()
            
            VStack(alignment: .leading) {
                TextField("Search to add", text: self.$bookTitle)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                    }
                    .padding(.top, 5)
            }
            .padding(.top)
            
            List(self.books, id: \.self) { book in
                HStack {
                    HorizontalBookPreview(bookName: book, descriptionLineLimit: 4)
                    
                    Spacer(minLength: 25)
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(.plain)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .padding()
    }
}

#Preview {    
    AddBookView()
}
