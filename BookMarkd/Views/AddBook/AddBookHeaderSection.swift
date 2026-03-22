//
//  AddBookHeaderSection.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 22/03/26.
//

import SwiftUI

struct AddBookHeaderSection: View {
    @Binding var bookTitle: String
    
    let handleTapOnAddBookManually: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            TextField("Search for your next adventure", text: $bookTitle)
                .padding(.horizontal, 10)
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 7)
                .stroke(.gray, lineWidth: 1)
        }
        
        HStack(alignment: .center, spacing: 10) {
            RoundedRectangleButton(buttonText: "Scan Cover",
                                   imageName: "camera.fill",
                                   buttonFillColor: Color.neutralButton,
                                   buttonTextColor: Color.accent,
                                   cornerRadius: 8) {
                
            }
            
            RoundedRectangleButton(buttonText: "Edit Manually",
                                   imageName: "rectangle.and.pencil.and.ellipsis",
                                   buttonFillColor: Color.neutralButton,
                                   buttonTextColor: Color.accent,
                                   cornerRadius: 8) {
                self.handleTapOnAddBookManually()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    AddBookHeaderSection(bookTitle: .constant(""), handleTapOnAddBookManually: {
        
    })
    .padding()
}
