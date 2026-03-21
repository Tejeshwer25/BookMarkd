//
//  APIClient.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 18/01/26.
//

import Foundation

struct APIClient {
    let session: URLSession = .shared
    let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
    
    func send<T: Decodable>(_ request: URLRequest, as type: T.Type = T.self) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
                throw APIError.invalidStatusCode
            }
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decoding
            }
        } catch {
            throw APIError.transport
        }
    }
    
    func send(_ request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
                throw APIError.invalidStatusCode
            }
            
            return data
        } catch {
            throw APIError.transport
        }
    }
}
