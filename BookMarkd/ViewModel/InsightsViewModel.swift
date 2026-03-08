//
//  InsightsViewModel.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 01/03/26.
//

import Foundation
import Combine

struct ReadingActivityLastSixMonths: Identifiable {
    let id: UUID = UUID()
    let bookCount: Int
    let date: Date
    
    init(bookCount: Int, date: Date) {
        let calendar = Calendar.autoupdatingCurrent
        self.bookCount = bookCount
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        self.date = calendar.date(from: DateComponents(year: year, month: month)) ?? .now
    }
}

@MainActor
class InsightsViewModel: ObservableObject {
    @Published var readingActivity: [ReadingActivityLastSixMonths] = []
    @Published var genresRead: [BookGenre: Int] = [:]
    
    /// Method to get list of books finished this month by the user
    /// - Parameter allBooks: all books read by user
    /// - Returns: number of books read this month
    func getBooksFinishedThisMonth(allBooks: [BookModel]) -> Int {
        let finishedBooks = self.getTotalFinishedBooks(allBooks: allBooks)
        
        let booksFinishedThisMonth = finishedBooks.filter { book in
            guard let finishedDate = book.finishedAt else { return false }
            let calendar = Calendar.current
            
            print("Finished Date: \(finishedDate)")
            let currentMonth = calendar.component(.month, from: Date())
            let bookMonth = calendar.component(.month, from: finishedDate)
            let currentYear = calendar.component(.year, from: Date())
            let bookYear = calendar.component(.year, from: finishedDate)
            
            return (currentYear == bookYear && currentMonth == bookMonth)
        }
        return booksFinishedThisMonth.count
    }
    
    /// method to get books that are finished by user
    /// - Parameter allBooks: all books user has in their library
    /// - Returns: books user has finished
    func getTotalFinishedBooks(allBooks: [BookModel]) -> [BookModel] {
        let finishedbooks = allBooks.filter { $0.readState == .read }
        return finishedbooks
    }
    
    /// Method to get average book rating
    /// - Parameter allBooks: all books in user library
    /// - Returns: average rating given
    func getAverageRatingGivenToBooksByUser(allBooks: [BookModel]) -> Double {
        let finishedBooks = self.getTotalFinishedBooks(allBooks: allBooks)
        guard finishedBooks.count > 0 else { return 0 }
        
        let rating = finishedBooks.compactMap(\.rating).reduce(0, +)
        let averageRating: Double = Double(rating) / Double(finishedBooks.count)
        
        return averageRating
    }
    
    
    /// Method to get number of quotes saved by user till now
    /// - Parameter allBooks: all books finished by user
    /// - Returns: number of quotes saved
    func getQuotesSavedByUser(allBooks: [BookModel]) -> Int {
        let finishedBooks = self.getTotalFinishedBooks(allBooks: allBooks)
        let quotesSavedCount = finishedBooks.reduce(0) { count, book in
            count + book.quotes.count
        }
        return quotesSavedCount
    }
    
    /// Method to get data for last 6 months reading activity and populate he published state of viewmodel
    /// - Parameter allBooks: all books in users library
    func loadChartData(allBooks: [BookModel]) {
        let books = self.getTotalFinishedBooks(allBooks: allBooks)
        
        Task {
            let activity = await Task.detached(priority: .userInitiated) {
                self.computeActivity(from: books)
            }.value
            
            
            self.readingActivity = activity
                .map { ReadingActivityLastSixMonths(bookCount: $0.value, date: $0.key) }
                .sorted { $0.date < $1.date }
        }
    }
    
    /// Method to offload heavy computation for books read each month away from Main Actor
    /// - Parameter books: all finished books in user library
    /// - Returns: Books read on each date
    private nonisolated func computeActivity(from books: [BookModel]) -> [Date: Int] {
        let calendar = Calendar.current
        let now = Date()
        var monthBuckets: [Date: Int] = [:]
        for i in 0..<6 {
            if let month = calendar.date(byAdding: .month, value: -i, to: now) {
                let startOfMonth = calendar.date(from: calendar.dateComponents([.year,.month], from: month))!
                monthBuckets[startOfMonth] = 0
            }
        }
        
        for book in books {
            guard let finished = book.finishedAt else { continue }
            
            let month = calendar.date(from:
                                        calendar.dateComponents([.year,.month], from: finished)
            )!
            
            monthBuckets[month, default: 0] += 1
        }
        
        return monthBuckets
    }
}
