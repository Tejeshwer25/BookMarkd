//
//  FinishBookView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 05/01/26.
//

import SwiftUI

struct FinishBookView: View {
    @EnvironmentObject private var router: Router
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack {
                    AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400")) { image in
                        image
                            .resizable()
                            .frame(width: 175, height: 225)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } placeholder: {
                        Text("Loading Image...")
                    }
                    
                    Text("You finished reading")
                        .padding()
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Text("The Midnight Library")
                        .font(.title2)
                    
                    Text("Matt Haig")
                        .padding(.top, 3)
                    
                    
                    Text("How would you rate it?")
                        .padding(.top, 50)
                        .padding(.bottom)
                    
                    HStack {
                        ForEach(1...5, id: \.self) { rating in
                            Button {
                            } label: {
                                Image(systemName: rating < 3 ? "star.fill" : "star")
                                    .font(.system(size: 30))
                                    .foregroundColor(rating < 3 ? .yellow: .gray)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                Text("Final Thoughts")
                    .padding(.top, 50)
                    .padding(.bottom)
                
                TextEditor(text: .constant("Placeholder"))
                    .padding(6)
                    .frame(height: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    
                Button {
                    self.router.popToRoot()
                } label: {
                    Text("Mark As Finished")
                        .padding(.horizontal, 50)
                        .padding(.vertical)
                        .foregroundStyle(.black)
                        .background {
                            Capsule()
                                .foregroundStyle(.white)
                        }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    NavigationStack {
        FinishBookView()
    }
}
