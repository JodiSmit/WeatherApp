//
//  APIEndpoint.swift
//  WeatherApp
//
//  Created by Jodi Smit on 4/12/23.
//

import Foundation

enum APIEndpoints {
    case getCurrentWeather(latitude: String, longitude: String)
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
}

extension APIEndpoints {

    var path: String {
        switch self {
        case .getCurrentWeather(_, _):
            return "/data/2.5/weather"
        }
    }

    var method: APIEndpoints.Method {
        switch self {
        default:
            return .GET
        }
    }

    var parameters: [URLQueryItem]? {
        switch self {
        case .getCurrentWeather(let latitude, let longitude):
            let queryItems = [
                URLQueryItem(name: "lat", value: latitude),
                URLQueryItem(name: "lon", value: longitude),
                URLQueryItem(name: "units", value: "imperial"),
                URLQueryItem(name: "appid", value: APIHelper.apiKey)
            ]
            return queryItems
        }
    }
}
