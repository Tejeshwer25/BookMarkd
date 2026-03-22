//
//  FlowLayout.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 03/02/26.
//

import SwiftUI

struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let items: Data
    let spacing: CGFloat
    let rowSpacing: CGFloat
    let maxRows: Int? // when nil, show all rows
    let content: (Data.Element) -> Content
    let alignment: HorizontalAlignment

    init(items: Data, spacing: CGFloat = 8, rowSpacing: CGFloat = 8, maxRows: Int? = nil, alignment: HorizontalAlignment = .center, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.items = items
        self.spacing = spacing
        self.rowSpacing = rowSpacing
        self.maxRows = maxRows
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        // Use the current screen width as an approximation for available width inside the container.
        // If your container has horizontal padding, you can subtract it here to improve wrapping accuracy.
        let availableWidth = UIScreen.main.bounds.width - 32 // adjust if your container padding changes
        let rows = computeRows(for: availableWidth)

        return VStack(alignment: alignment, spacing: rowSpacing) {
            ForEach(0..<(maxRows.map { min($0, rows.count) } ?? rows.count), id: \.self) { rowIndex in
                HStack(alignment: .center, spacing: spacing) {
                    ForEach(rows[rowIndex], id: \.self) { item in
                        content(item)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func computeRows(for availableWidth: CGFloat) -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRowWidth: CGFloat = 0

        // A rough measurement helper using UILabel via NSString to avoid relying on SwiftUI layout pass.
        func measure(_ viewText: String) -> CGFloat {
            let padding: CGFloat = 20 + 20 // horizontal paddings left+right in the chip
            let font = UIFont.preferredFont(forTextStyle: .body)
            let size = (viewText as NSString).size(withAttributes: [.font: font])
            return size.width + padding
        }

        for item in items {
            // We assume item is a String for measurement; if not, fallback to a default width
            let itemWidth: CGFloat
            if let text = item as? String {
                itemWidth = measure(text)
            } else {
                itemWidth = 80 // fallback width
            }

            if currentRowWidth == 0 { // first item in row
                rows[rows.count - 1].append(item)
                currentRowWidth = itemWidth
            } else if currentRowWidth + spacing + itemWidth <= availableWidth {
                rows[rows.count - 1].append(item)
                currentRowWidth += spacing + itemWidth
            } else {
                rows.append([item])
                currentRowWidth = itemWidth
            }
        }

        return rows
    }
}
