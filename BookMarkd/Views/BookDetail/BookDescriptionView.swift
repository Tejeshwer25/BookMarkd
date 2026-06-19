//
//  BookDescriptionView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 19/06/26.
//

import SwiftUI

struct BookDescriptionView: View {
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Description")
                .sectionTitleStyle()
            
            Text(description)
                .font(.callout)
        }
    }
}
