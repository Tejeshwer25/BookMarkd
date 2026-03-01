//
//  RecommendationService.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 16/02/26.
//

import FoundationModels

@Generable struct RecommendedBooks {
    let bookTitle: String
    let bookAuthor: String
    @Guide(description: "An explanatory book description, not giving any spoilers") let bookDescription: String
    @Guide(description: "A reason why this book might be recommended to the user") let whyRecommendation: String
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
}
