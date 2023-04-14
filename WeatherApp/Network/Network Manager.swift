//
//  Network Manager.swift
//  WeatherApp
//
//  Created by Jodi Smit on 4/12/23.
//

import Foundation

enum NetworkError: Error {
    case dataError
    case invalidPath
    case decoding
    
    var description: String {
        switch self {
        case .dataError:
            return "There's an issue with the data"
        case .invalidPath:
            return "Invalid Path"
        case .decoding:
            return "There was an error decoding the type"
        }
    }
}

class NetworkManager {
    
    typealias NetworkResponse = (data: Data, response: URLResponse)
    static let shared = NetworkManager()
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
      
    func getData<D: Decodable>(from endpoint: APIEndpoints) async throws -> D {
        let request = try createRequest(from: endpoint)
        let response: NetworkResponse = try await session.data(for: request)
        return try decoder.decode(D.self, from: response.data)
    }
    
    func sendData<D: Decodable, E: Encodable>(from endpoint: APIEndpoints, with body: E) async throws -> D {
        let request = try createRequest(from: endpoint)
        let data = try encoder.encode(body)
        let response: NetworkResponse = try await session.upload(for: request, from: data)
        return try decoder.decode(D.self, from: response.data)
    }
}

extension NetworkManager {
    
    private func createRequest(from endpoint: APIEndpoints) throws -> URLRequest {
        
        guard var components = URLComponents(string: APIHelper.baseURL) else { throw NetworkError.invalidPath }
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        guard let urlPath = components.url else { throw NetworkError.invalidPath }

        return URLRequest(url: urlPath)
    }
}
