//
//  InsightsView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 28/02/26.
//

import SwiftUI
import Charts
import SwiftData

struct MonthlyHoursOfSunshine: Identifiable {
    var id = UUID()
    var date: Date
    var hoursOfSunshine: Double


    init(month: Int, hoursOfSunshine: Double) {
        let calendar = Calendar.autoupdatingCurrent
        self.date = calendar.date(from: DateComponents(year: 2020, month: month))!
        self.hoursOfSunshine = hoursOfSunshine
    }
}

struct InsightsView: View {
    @EnvironmentObject private var router: Router
    @Query private var books: [BookModel]
    @StateObject private var viewModel = InsightsViewModel()
    
    var data: [MonthlyHoursOfSunshine] = [
        MonthlyHoursOfSunshine(month: 1, hoursOfSunshine: 74),
        MonthlyHoursOfSunshine(month: 2, hoursOfSunshine: 99),
        MonthlyHoursOfSunshine(month: 12, hoursOfSunshine: 62)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                Text("Your reading patterns and progress")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Based on your activity over the last 30 days.")
                    .font(.callout)
                    .fontWeight(.light)
                
                VStack(alignment: .center, spacing: 12) {
                    HStack {
                        RoundedBoxContainer(shouldShowTag: true,
                                            icon: "calendar",
                                            title: "Books Finished",
                                            value: "\(self.viewModel.getBooksFinishedThisMonth(allBooks: books))",
                                            tagText: "Monthly")
                        Spacer()
                        RoundedBoxContainer(icon: "book.pages",
                                            title: "Total Finished",
                                            value: "\(self.viewModel.getTotalFinishedBooks(allBooks: books).count)")
                    }
                    
                    HStack {
                        RoundedBoxContainer(icon: "star",
                                            title: "Avg Rating",
                                            value: String(format: "%.2f", self.viewModel.getAverageRatingGivenToBooksByUser(allBooks: books)))
                        Spacer()
                        RoundedBoxContainer(icon: "quote.opening",
                                            title: "Quotes Saved",
                                            value: "\(self.viewModel.getQuotesSavedByUser(allBooks: books))")
                    }
                }
                .padding(.top, 24)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Reading Acitvity")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("Last 6 Months")
                            .font(.caption)
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
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            .fill(Color.neutralButton.opacity(0.1))
                    }
                }
                .fontDesign(.serif)
                .padding(.top, 32)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .fontDesign(.serif)
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
                }
            }
        }
    }
}
