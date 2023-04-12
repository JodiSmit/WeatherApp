//
//  Network Manager.swift
//  WeatherApp
//
//  Created by Jodi Smit on 4/12/23.
//

import Foundation

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

private extension NetworkManager {
    
    func createRequest(from endpoint: APIEndpoints) throws -> URLRequest {
        guard
            let urlPath = URL(string: APIHelper.baseURL.appending(endpoint.path)),
            var urlComponents = URLComponents(string: urlPath.path)
        else {
            throw NetworkError.invalidPath
        }
        
        if let parameters = endpoint.parameters {
            urlComponents.queryItems = parameters
        }
        
        var request = URLRequest(url: urlPath)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}


enum NetworkError: Error {
    case invalidPath
    case decoding
    
    var description: String {
        switch self {
        case .invalidPath:
            return "Invalid Path"
        case .decoding:
            return "There was an error decoding the type"
        }
    }
}
