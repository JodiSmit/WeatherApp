//
//  APIEndpoint.swift
//  WeatherApp
//
//  Created by Jodi Smit on 4/12/23.
//

import Foundation

enum APIEndpoint {
    case getCurrentWeather(latitude: String, longitude: String, units: String?)
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
}

extension APIEndpoint {

    /// The path for every endpoint
    var path: String {
        switch self {
        case .getCurrentWeather(_, _, _):
            return "/data/2.5/weather"
        }
    }
    
    /// The method for the endpoint
    var method: APIEndpoint.Method {
        switch self {
        default:
            return .GET
        }
    }
    
    /// The URL parameters for the endpoint (in case it has any)
    var parameters: [URLQueryItem]? {
        switch self {
        case .getCurrentWeather(let latitude, let longitude, let units):
            let queryItems = [
                URLQueryItem(name: "lat", value: latitude),
                URLQueryItem(name: "lon", value: longitude),
                URLQueryItem(name: "units", value: units),
                URLQueryItem(name: "appid", value: APIHelper.apiKey)
            ]
            return queryItems
        }
    }
}
