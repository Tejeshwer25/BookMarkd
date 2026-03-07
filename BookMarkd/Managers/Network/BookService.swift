//
//  BookService.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/01/26.
//

import Foundation

protocol BookService {
    func searchBooks(_ query: String) async throws -> [SearchedBooks]
    func getBookDetails(_ bookID: String) async throws -> BookDetailDataModel
}

struct BookServiceUtility: BookService {
    let api: APIClient

    func searchBooks(_ query: String) async throws -> [SearchedBooks] {
        // Build request to Open Library search endpoint
        let request = try BookEndpoint.search(query: query).makeRequest()
        // Decode the Open Library response
        let response: OpenLibrarySearchResponse = try await api.send(request)
        // Map docs to your app's BookModel
        let books: [SearchedBooks] = response.docs.compactMap { doc in
            let title = doc.title
            let author = doc.authorNames
            let coverID = doc.coverID
            
            return SearchedBooks(id: doc.workKey ?? UUID().uuidString,
                             title: title ?? "",
                             authorName: author ?? [],
                             readState: .unread,
                             coverImageURL: buildCoverURL(from: coverID))
        }
        return books
    }
    
    func getBookDetails(_ bookID: String) async throws -> BookDetailDataModel {
        let request = try BookEndpoint.bookDetails(bookKey: bookID).makeRequest()
        let response = try await api.send(request)
        
        if let responseModel = OpenLibraryBookDetailsModel.decodeDataModel(from: response) {
            let book: BookDetailDataModel = BookDetailDataModel(id: responseModel.key,
                                                                title: responseModel.title,
                                                                description: responseModel.description,
                                                                places: responseModel.subjectPlaces,
                                                                characters: responseModel.subjectPeople,
                                                                genre: responseModel.subjects)
            return book
        } else if let responseModel = FallbackOpenLibraryBookDetailsModel.decodeDataModel(from: response) {
            let book = BookDetailDataModel(id: responseModel.key,
                                           title: responseModel.title,
                                           description: responseModel.description.value,
                                           places: responseModel.subjectPlaces,
                                           characters: responseModel.subjectPeople,
                                           genre: responseModel.subjects)
            return book
        } else {
            throw APIErrors.failedToDecode
        }
    }

    private func buildCoverURL(from coverID: Int?) -> String? {
        if let coverID {
            return "https://covers.openlibrary.org/b/id/\(coverID)-M.jpg"
        } else {
            return nil
        }
    }
}
