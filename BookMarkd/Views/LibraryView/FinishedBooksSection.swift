//
//  FinishedBooksSection.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/02/26.
//

import SwiftUI

struct FinishedBooksSection: View {
    let viewModel: LibraryViewModel
    let finishedBookList: [BookModel]
    let onBookComponentTap: (String) -> Void
    
    var body: some View {
        if self.finishedBookList.isEmpty {
            self.emptyFinishedBooksView
        } else {
            self.finishedBookView
        }
    }
    
    var finishedBookView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Finished Books")
                    .font(.title3)
                
                Spacer()
                
                if self.finishedBookList.count > 2 {
                    Button {
                        
                    } label: {
                        Text("Archive")
                            .foregroundStyle(Color.yellow)
                            .fontWeight(.bold)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            ForEach(self.finishedBookList) { book in
                Button {
                    self.onBookComponentTap(book.id)
                } label: {
                    HStack {
                        BookImage(bookImageURL: book.coverImageURL ?? "",
                                  imageFrame: (75, 100))
                        
                        VStack(alignment: .leading) {
                            Text(book.title)
                                .font(.headline)
                            
                            Text(book.authorName.joined(separator: ", "))
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                
                                Text("\(book.rating ?? 0)")
                            }
                        }
                        
                        Spacer(minLength: 25)
                        
                        VStack {
                            Text("FINISHED")
                                .fontWeight(.bold)
                            
                            Text(self.viewModel.getFinishedBookDate(book: book))
                        }
                        .font(.caption)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            .fill(Color.indigo.opacity(0.1))
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .fontDesign(.serif)
    }
    
    var emptyFinishedBooksView: some View {
        VStack(alignment: .center, spacing: 5) {
            Image(systemName: "checkmark.circle")
                .resizable()
                .frame(width: 36, height: 36)
                .padding(.bottom, 10)
            
            Text("No finished books yet.")
                .font(.headline)
            
            Text("Complete a book to see it here.")
        }
        .fontDesign(.serif)
        .frame(maxWidth: .infinity)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                .fill(Color.blue.opacity(0.1))
        }
    }
}

#Preview {
    FinishedBooksSection(viewModel: .init(),
                         finishedBookList: [],
                         onBookComponentTap: {print($0)})
}
