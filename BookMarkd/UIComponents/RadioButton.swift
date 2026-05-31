//
//  RadioButton.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 15/05/26.
//

import SwiftUI

struct RadioButton: View {
    @Binding var selectedNoteType: NoteType
    let noteType: NoteType
    var onChange: (NoteType) -> Void
    
    var body: some View {
        let isSelected = selectedNoteType == noteType
        
        Button {
            withAnimation {
                onChange(noteType)
            }
        } label: {
            Text(self.noteType.text)
                .font(EditorialSans.button)
                .foregroundStyle(isSelected ? Color.SURFACE : Color.ON_SURFACE)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background {
                    Capsule()
                        .stroke(Color.primaryBrand)
                        .fill(isSelected ? .primaryBrand : .clear)
                }
        }
    }
}
