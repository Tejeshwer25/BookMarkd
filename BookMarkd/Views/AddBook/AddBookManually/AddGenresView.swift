//
//  AddGenresView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 22/03/26.
//

import SwiftUI

struct AddGenresView: View {
    @Environment(\.dismiss) var dismiss
    @State private var genresSelected: Set<BookGenre> = []
    
    let addGenresToBook: ([BookGenre]) -> Void
    let hapticsManager = HapticManager.shared
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5, alignment: .center), count: 2), spacing: 5) {
                ForEach(BookGenre.allCases, id: \.self) { item in
                    RoundedRectangleButton(
                        buttonText: item.rawValue,
                        imageName: nil,
                        buttonFillColor: genresSelected.contains(item) ? .primaryBrand : .neutral,
                        buttonTextColor: genresSelected.contains(item) ? .neutral : .primaryBrand,
                        buttonBorderColor: genresSelected.contains(item) ? .neutral : .primaryBrand,
                        buttonPaddingHorizontal: 8,
                        buttonPaddingVertical: 8
                    ) {
                        withAnimation {
                            if genresSelected.contains(item) {
                                genresSelected.remove(item)
                            } else {
                                genresSelected.insert(item)
                            }
                        }
                        hapticsManager.trigger(.impactLight)
                    }
                }
            }
            .padding()
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    addGenresToBook(Array(genresSelected))
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddGenresView() { _ in }
    }
}
