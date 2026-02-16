//
//  ShareQuoteView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 15/02/26.
//

import SwiftUI

@MainActor
struct ShareQuoteView: View {
    @Environment(\.dismiss) var dismiss
    @State private var scrollPosition: Int? = 1
    let book: BookModel?
    let quote: QuotesModel?
    let onDismiss: ((UIImage) -> Void)?
    
    let views = [
        LinearGradient(colors: [.brown.opacity(0.95), .orange.opacity(0.65)],
                       startPoint: .top,
                       endPoint: .bottomTrailing),
        LinearGradient(colors: [.purple.opacity(0.65), .blue.opacity(0.75), .black],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing),
        LinearGradient(colors: [Color(.secondaryLabel), Color(.tertiaryLabel)],
                       startPoint: .topLeading,
                       endPoint: .bottom),
        LinearGradient(colors: [.green.opacity(0.95), .brown.opacity(0.95)],
                       startPoint: .topLeading,
                       endPoint: .bottom),
        LinearGradient(colors: [.indigo.opacity(0.75), .black.opacity(0.75)],
                             startPoint: .topLeading,
                             endPoint: .bottom)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(0..<views.count, id: \.self) { item in
                        cardView(item)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, 30, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $scrollPosition)
            
            Button(action: {
                if let current = scrollPosition {
                    HapticManager.shared.trigger(.success)
                    print("Performing action on: Item \(current)")
                    let card = ShareableCardView(views: views,
                                                 quote: quote,
                                                 book: book,
                                                 index: scrollPosition ?? 0).padding()
                    let image = card.renderAsImage()
                    dismiss()
                    onDismiss?(image)
                }
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share Quote")
                }
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(12)
            .padding()
        }
        .navigationTitle("Choose your theme!")
        .navigationBarTitleDisplayMode(.inline)
        .presentationDetents([.height(500), .large])
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    HapticManager.shared.trigger(.success)                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
    
    @ViewBuilder
    func cardView(_ index: Int) -> some View {
        ShareableCardView(views: views,
                          quote: quote,
                          book: book,
                          index: index)
        .visualEffect { content, geometryProxy in
            content
                .scaleEffect(ShareQuoteView.calculateScale(proxy: geometryProxy))
                .opacity(ShareQuoteView.calculateOpacity(proxy: geometryProxy))
        }
    }
    
    // Logic to shrink items as they move away from center
    nonisolated static func calculateScale(proxy: GeometryProxy) -> CGFloat {
        let minScale: CGFloat = 0.8
        let diff = abs(proxy.frame(in: .scrollView).midX - proxy.bounds(of: .scrollView)!.midX)
        let scale = 1 - (diff / 500)
        return max(minScale, scale)
    }
    
    // Logic to fade items as they move away from center
    nonisolated static func calculateOpacity(proxy: GeometryProxy) -> CGFloat {
        let minOpacity: CGFloat = 0.4
        let diff = abs(proxy.frame(in: .scrollView).midX - proxy.bounds(of: .scrollView)!.midX)
        let opacity = 1 - (diff / 900)
        return max(minOpacity, opacity)
    }
}

struct ShareableCardView: View {
    let views: [LinearGradient]
    let quote: QuotesModel?
    let book: BookModel?
    let index: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(views[index])
            .overlay {
                VStack {
                    Image(systemName: "quote.opening")
                    Text(quote?.text ?? "")
                        .padding()
                        .fontDesign(.serif)
                        .font(.headline)
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    VStack {
                        Color.black.opacity(0.5)
                            .frame(height: 0.34)
                            .padding(.horizontal)
                        Text(book?.title ?? "")
                            .fontDesign(.serif)
                            .font(.caption)
                            .padding(.top)
                        
                        Text(book?.authorName.joined(separator: ", ") ?? "")
                            .font(.caption2)
                            .fontDesign(.serif)
                            .padding(.top, 1)
                    }
                    
                }
                .padding()
            }
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(views[index], lineWidth: 2)
            }
            .frame(width:350, height: 450)
    }
}

extension View {
    func renderAsImage() -> UIImage {
        let renderer = ImageRenderer(content: self)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage ?? UIImage()
    }
}

#Preview {
    ShareQuoteView(book: nil, quote: nil) { image in
        ()
    }
}
