//
//  RecommendationService.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 16/02/26.
//

import FoundationModels
import Foundation

@Generable struct RecommendedBooks {
    let bookTitle: String
    let bookAuthor: String
    @Guide(description: "An explanatory book description, not giving any spoilers") let bookDescription: String
    @Guide(description: "A reason why this book might be recommended to the user") let whyRecommendation: String
}

@Generable struct BookDescription {
    @Guide(description: "An explanatory book description, not giving any spoilers") let bookDescription: String
    @Guide(description: "Genres in which this book might fit") let bookGenres: [String]
    @Guide(description: "Error incase you have no knowledge about the book") let errorMessage: String?
}

@Generable struct BookExtracted {
    @Guide(description: "Book title extracted from ocr text") let bookTitle: String
    @Guide(description: "Book author name extracted from ocr text") let bookAuthor: String
    @Guide(description: "An explanatory book description, not giving any spoilers") let bookDescription: String
    @Guide(description: "Genres in which this book might fit") let bookGenres: [String]
}

struct RecommendationService {
    private let instruction = """
        Your task is to generate a list of 5 books which matches the user's taste. It should be a mix of the genres user is currently reading and a genre user might love to explore. Also the books should not be in users already read section.
        """
    
    func generateRecommendations(from books: [BookModel], with preferences: [String]) async throws -> [RecommendedBooks] {
        // Use FoundationModels here
        let bookTitlesRead = books.map(\.title).joined(separator: ", ")
        let session = LanguageModelSession(instructions: instruction)
        let response = try await session.respond(to: "Generate 5 book titles user might love to read based on the instructions provided. The current book titles read by user are: \(bookTitlesRead). The list of genres preferred by user are: \(preferences)", generating: [RecommendedBooks].self)
        let content = response.content
        return content
    }
    
    func generateBookDescriptionAndGenres(for book: BookModel) async throws -> BookModel {
        let instruction = """
            Your task is to generate description for the book titled: \(book.title), written by \(book.authorName.first ?? "n/a"). Also map this book to any genres that you find fit from the following list: \(BookGenre.allCases.map({$0.rawValue})). If there is no knowledge about this book leave the fields blank, and populate the error message. If you fill in description and genres leave the error as empty string
        """
        
        let session = LanguageModelSession(instructions: instruction)
        let response = try await session.respond(to: "Generate description and genres for the book: \(book.title) written by: \(book.authorName). Leave Error field as empty string if you have filled in description and genres", generating: BookDescription.self)
        let newBook = book
        
        print(response.content)
        if let error = response.content.errorMessage, error.isEmpty == false {
            return newBook
        }
        
        newBook.bookDescription = response.content.bookDescription
        newBook.themes = response.content.bookGenres
        
        return newBook
    }
    
    func getBookDetailsFromBookCover(for extractedText: String) async throws -> BookModel {
        let promptSystem = """
        Your task is to extract meaningful information from the OCR text, which contains data read from book cover image. I want you to map data into its meaningful context as in book title, author name and whatever you can intelligently guess about the book. Also generate description. Also map this book to any genres that you find fit from the following list: \(BookGenre.allCases.map({$0.rawValue})). 
        """
        
        let session = LanguageModelSession(instructions: instruction)
        let response = try await session.respond(to: """
                                                 Extract book metadata from the following OCR text:
                                                 \"\"\"
                                                 \(extractedText)
                                                 \"\"\"
                                                 """, generating: BookExtracted.self)
        let newBook = BookModel(id: UUID().uuidString,
                                title: response.content.bookTitle,
                                authorName: [response.content.bookAuthor],
                                readState: .wishlist,
                                bookDescription: response.content.bookDescription,
                                themes: response.content.bookGenres)
        return newBook
    }
}
