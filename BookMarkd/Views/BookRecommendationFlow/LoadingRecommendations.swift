//
//  LoadingRecommendations.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/02/26.
//

import SwiftUI

struct LoadingRecommendations: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Finding your next read...")
                .bookTitleStyle()
                .italic()
            
            Text("Searching through thousands of shelves across digital expanse.")
                .metadataStyle()
                .padding(.bottom, 25)
                .lineLimit(2)
            
            ForEach(0..<3) { _ in
                HStack(alignment: .top, spacing: 15) {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 100, height: 150)
                        .foregroundStyle(LinearGradient(colors: [Color.SURFACE_LOW, Color.SURFACE_LOWEST],
                                                        startPoint: .leading,
                                                        endPoint: .trailing))
                    
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 200, height: 25)
                            .foregroundStyle(LinearGradient(colors: [Color.SURFACE_LOW, Color.SURFACE_LOWEST],
                                                            startPoint: .leading,
                                                            endPoint: .trailing))
                        
                        RoundedRectangle(cornerRadius: 8)
                            .frame(maxWidth: 150, maxHeight: 25)
                            .foregroundStyle(LinearGradient(colors: [Color.SURFACE_LOW, Color.SURFACE_LOWEST],
                                                            startPoint: .leading,
                                                            endPoint: .trailing))
                        
                        HStack(spacing: 10) {
                            Capsule()
                                .frame(maxWidth: 75, maxHeight: 25)
                                .foregroundStyle(LinearGradient(colors: [Color.SURFACE_LOW, Color.SURFACE_LOWEST],
                                                                startPoint: .leading,
                                                                endPoint: .trailing))
                            
                            Capsule()
                                .frame(maxWidth: 75, maxHeight: 25)
                                .foregroundStyle(LinearGradient(colors: [Color.SURFACE_LOW, Color.SURFACE_LOWEST],
                                                                startPoint: .leading,
                                                                endPoint: .trailing))
                        }
                        .padding(.vertical)
                        
                    }
                    .padding(.vertical)
                }
                .padding(.vertical, 5)
            }
        }
    }
}
