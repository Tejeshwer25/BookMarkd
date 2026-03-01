//
//  InsightsView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 28/02/26.
//

import SwiftUI
import Charts

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
                                            value: "4",
                                            tagText: "Monthly")
                        Spacer()
                        RoundedBoxContainer(icon: "book.pages",
                                            title: "Total Finished",
                                            value: "10")
                    }
                    
                    HStack {
                        RoundedBoxContainer(icon: "star",
                                            title: "Avg Rating",
                                            value: "3")
                        Spacer()
                        RoundedBoxContainer(icon: "quote.opening",
                                            title: "Quotes Saved",
                                            value: "40")
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
                    
                    Chart(data) {
                        LineMark(
                                    x: .value("Month", $0.date),
                                    y: .value("Hours of Sunshine", $0.hoursOfSunshine)
                                )
                    }
                    .frame(height: 178)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            .fill(Color.blue.opacity(0.1))
                    }
                }
                .fontDesign(.serif)
                .padding(.top, 32)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Top Genres")
                            .font(.headline)
                    
                    VStack(spacing: 16) {
                        BookProgressBar(genreName: "Mystery",
                                        numberOfBooks: 10,
                                        totalBooks: 12)
                        BookProgressBar(genreName: "Mystery",
                                        numberOfBooks: 10,
                                        totalBooks: 12)
                        BookProgressBar(genreName: "Mystery",
                                        numberOfBooks: 10,
                                        totalBooks: 12)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            .fill(Color.blue.opacity(0.1))
                    }
                }
                .padding(.top, 32)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .fontDesign(.serif)
        }
    }
}


#Preview {
    var router = Router()
    NavigationStackContainer(router: router) {
        InsightsView()
    }
}
