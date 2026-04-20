//
//  SearchView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 27/12/25.
//

//import SwiftUI
//
//struct SearchView: View {
//    @Binding var results: [BookModel]
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            ForEach(results, id: \.self.id) { result in
//                HStack {
//                    BookImage(bookImageURL: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400", imageFrame: (width: 75, height: 100))
//                    
//                    VStack(alignment: .leading) {
//                        Text(result.title)
//                            .font(.headline)
//                        Text(result.authorName.joined())
//                            .font(.callout)
//                    }
//                    .padding(.vertical)
//                    .padding(.leading)
//                    
//                    Spacer()
//                    
//                    Button {
//                        print("Book Added to library")
//                    } label: {
//                        Image(systemName: "plus.circle")
//                            .resizable()
//                            .frame(width: 25, height: 25)
//                    }
//                }
//            }
//            .padding()
//        }
//        .frame(maxWidth: .infinity)
//    }
//}
//
//#Preview {
//    SearchView(results: .constant([]))
//}
