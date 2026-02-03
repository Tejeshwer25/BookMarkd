//
//  BookService.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/01/26.
//

import Foundation

protocol BookService {
    func searchBooks(_ query: String) async throws -> [BookModel]
    func getBookDetails(_ bookID: String) async throws -> BookDetailDataModel
}

struct BookServiceUtility: BookService {
    let api: APIClient

    func searchBooks(_ query: String) async throws -> [BookModel] {
        // Build request to Open Library search endpoint
        let request = try BookEndpoint.search(query: query).makeRequest(baseURL: api.baseURL)
        // Decode the Open Library response
        let response: OpenLibrarySearchResponse = try await api.send(request)
        // Map docs to your app's BookModel
        let books: [BookModel] = response.docs.compactMap { doc in
            let title = doc.title
            let author = doc.authorNames
            let coverID = doc.coverID
            
            return BookModel(id: doc.workKey ?? UUID().uuidString,
                             title: title ?? "",
                             authorName: author ?? [],
                             readState: .unread,
                             coverImageURL: buildCoverURL(from: coverID),
                             quotes: [])
        }
        return books
    }
    
    func getBookDetails(_ bookID: String) async throws -> BookDetailDataModel {
        let request = try BookEndpoint.bookDetails(bookKey: bookID).makeRequest(baseURL: api.baseURL)
        let response: OpenLibraryBookDetailsModel = try await api.send(request)
        
        let book: BookDetailDataModel = BookDetailDataModel(id: response.key,
                                                            title: response.title,
                                                            description: response.description,
                                                            places: response.subjectPlaces,
                                                            characters: response.subjectPeople,
                                                            genre: response.subjects)
        
        return book
    }

    private func buildCoverURL(from coverID: Int?) -> String? {
        if let coverID {
            return "https://covers.openlibrary.org/b/id/\(coverID)-M.jpg"
        } else {
            return nil
        }
    }
}
