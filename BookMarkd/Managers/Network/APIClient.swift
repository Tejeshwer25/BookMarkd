//
//  APIClient.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/01/26.
//

import Foundation

struct APIClient {
    let baseURL: URL
    let session: URLSession = .shared
    let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
    
    func send<T: Decodable>(_ request: URLRequest, as type: T.Type = T.self) async throws -> T {
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw APIError.invalidStatusCode((response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        return try decoder.decode(T.self, from: data)
    }
    
    func send(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw APIError.invalidStatusCode((response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        return data
    }
}

enum APIError: Error {
    case invalidStatusCode(Int)
    case decoding(Error)
    case transport(Error)
}
