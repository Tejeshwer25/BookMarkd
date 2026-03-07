//
//  BookEndpoints.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/01/26.
//

import Foundation

enum BookEndpoint {
    case search(query: String)
    case bookDetails(bookKey: String)
    
    var baseURL: URL {
        URL(string: "https://openlibrary.org")!
    }
    
    func makeRequest() throws -> URLRequest {
        switch self {
        case .search(let query):
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
            components?.path = "/search.json"
            var items: [URLQueryItem] = []
            if query.isEmpty == false {
                items.append(URLQueryItem(name: "q", value: query))
            }
            components?.queryItems = items
            
            guard let url = components?.url else { throw URLError(.badURL) }
            return self.getURLRequest(for: url)
        case .bookDetails(let bookKey):
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
            components?.path = "\(bookKey).json"
            
            guard let url = components?.url else { throw URLError(.badURL) }
            return self.getURLRequest(for: url)
        }
    }
    
    func getURLRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

private extension Optional where Wrapped == URL {
    func unwrap() throws -> URL {
        if let url = self { return url }
        throw URLError(.badURL)
    }
}
