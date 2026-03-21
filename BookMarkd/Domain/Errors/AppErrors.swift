//
//  AppErrors.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 08/03/26.
//

enum BookMarkdError: Error {
    case persistenceError
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .persistenceError: return "Persistence Error"
        case .apiError(let message): return message
        }
    }
}

enum APIError: Error {
    case invalidStatusCode
    case decoding
    case transport
    case badURL
}


enum PersistenceError: Error {
    case addBookFailed
    case removeBookFailed
    case addQuoteFailed
    case removeQuoteFailed
    case updateBookFailed
    case updateQuoteFailed
    case noBookFound
    case saveGenresFailed
    case userPreferenceNotFound
    
    var errrorDescription: String? {
        switch self {
        case .addBookFailed:
            return "Failed to add book"
        case .removeBookFailed:
            return "Failed to remove book"
        case .addQuoteFailed:
            return "Failed to add quote"
        case .removeQuoteFailed:
            return "Failed to remove quote"
        case .updateBookFailed:
            return "Failed to update book"
        case .updateQuoteFailed:
            return "Failed to update quote"
        case .noBookFound:
            return "No book found"
        case .saveGenresFailed:
            return "Failed to save genres"
        case .userPreferenceNotFound:
            return "User preference not found"
        }
    }
}
