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
      
    func makeRequest<T: Decodable>(with url: URL, httpMethod: String, requestBody: Data?, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(.failure(NetworkError.dataError))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(NetworkError.decoding))
            }
        }

        task.resume()
    }
}

extension NetworkManager {
    
    func createRequest(from endpoint: APIEndpoints) throws -> URLRequest {
        
        guard var components = URLComponents(string: APIHelper.baseURL) else { throw NetworkError.invalidPath }
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        guard let urlPath = components.url else { throw NetworkError.invalidPath }

        return URLRequest(url: urlPath)
    }
}
