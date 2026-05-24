//
//  AppErrors.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 08/03/26.
//

import Foundation

struct AlertInfoModel {
    let title: String
    let message: String
    let isVisible: Bool = false
}

enum BookMarkdError: LocalizedError {
    case persistenceError
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .persistenceError: return "Persistence Error"
        case .apiError(let message): return message
        }
    }
}

enum APIError: LocalizedError {
    case invalidStatusCode
    case decoding
    case transport
    case badURL
}


enum PersistenceError: LocalizedError {
    case addBookFailed
    case removeBookFailed
    case addQuoteFailed
    case removeQuoteFailed
    case updateBookFailed
    case updateQuoteFailed
    case noBookFound
    case saveGenresFailed
    case userPreferenceNotFound
    
    var errorDescription: String? {
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

enum FoundationModelErrors: LocalizedError {
    case appleIntelligenceNotEnabled
    case modelNotLoaded
    case unavailable
    
    case unableToGenerateResponse
    
    var errorDescription: String {
        switch self {
        case .appleIntelligenceNotEnabled: return "Apple Intelligence needs to be enabled for this feature to work."
        case .modelNotLoaded: return "AI model is not yet fully loaded. Please try again later."
        case .unavailable: return "AI model is currently not supported on this device."
            
        case .unableToGenerateResponse: return "AI model was unable to generate any response for the given data."
        }
    }
}
