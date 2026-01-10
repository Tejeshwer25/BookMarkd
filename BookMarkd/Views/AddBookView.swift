//
//  AddBookView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 11/01/26.
//

import SwiftUI

struct AddBookView: View {
    @Binding var bookTitle: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Add Book")
                    .font(.title)
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Title")
                        .font(.headline)
                    
                    TextField("Book Title", text: self.$bookTitle)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                        }
                        .padding(.top, 5)
                }
                .padding(.vertical)
                
                VStack(alignment: .leading) {
                    Text("Title")
                        .font(.headline)
                    
                    TextField("Book Title", text: self.$bookTitle)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                        }
                        .padding(.top, 5)
                }
                .padding(.vertical)
                
            }
        }
        
        .padding()
    }
}

#Preview {
    @Previewable @State var bookTitle: String = ""
    
    AddBookView(bookTitle: $bookTitle)
}
