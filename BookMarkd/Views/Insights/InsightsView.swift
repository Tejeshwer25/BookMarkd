//
//  InsightsView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 28/02/26.
//

import SwiftUI
import Charts
import SwiftData

struct InsightsView: View {
    @EnvironmentObject private var router: Router
    @Query private var books: [BookModel]
    @StateObject private var viewModel = InsightsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                Text("Your reading patterns and progress")
                    .font(EditorialSerif.displayMedium)
                
                Text("Based on your activity over the last 30 days.")
                    .metadataStyle()
                
                VStack(alignment: .center, spacing: 12) {
                    HStack {
                        RoundedBoxContainer(shouldShowTag: true,
                                            icon: "calendar",
                                            title: "Books Finished",
                                            value: "\(self.viewModel.getBooksFinishedThisMonth(allBooks: books))",
                                            tagText: "Monthly",
                                            iconColor: Color.PRIMARY_BRAND)
                        Spacer()
                        RoundedBoxContainer(icon: "book.pages",
                                            title: "Total Finished",
                                            value: "\(self.viewModel.getTotalFinishedBooks(allBooks: books).count)",
                                            iconColor: Color.PRIMARY_BRAND)
                    }
                    
                    HStack {
                        RoundedBoxContainer(icon: "star",
                                            title: "Avg Rating",
                                            value: String(format: "%.2f", self.viewModel.getAverageRatingGivenToBooksByUser(allBooks: books)),
                                            iconColor: Color.TERTIARY_BRAND)
                        Spacer()
                        RoundedBoxContainer(icon: "quote.opening",
                                            title: "Quotes Saved",
                                            value: "\(self.viewModel.getQuotesSavedByUser(allBooks: books))",
                                            iconColor: Color.TERTIARY_BRAND)
                    }
                }
                .padding(.top, 24)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Reading Activity")
                            .sectionTitleStyle()
                        
                        Spacer()
                        
                        Text("Last 6 Months")
                            .font(EditorialSans.caption)
                    }
                    
                    Chart(self.viewModel.readingActivity) {
                        LineMark(
                            x: .value("Month", $0.date),
                            y: .value("Books Read", $0.bookCount)
                        )
                    }
                    .chartXAxis { AxisMarks(preset: .automatic) { _ in AxisValueLabel() }}
                    .chartYAxis { AxisMarks(preset: .automatic) { _ in AxisValueLabel() }}
                    .frame(height: 178)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.SURFACE_LOW)
                    }
                }
                .padding(.top, 32)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .onAppear {
                self.viewModel.loadChartData(allBooks: self.books)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.router.pushScreen(.settings)
                } label: {
                    Image(systemName: "gear")
                        .accessibilityLabel("Settings")
                }
            }
        }
    }
}
