//
//  CurrentWeatherObject.swift
//  WeatherApp
//
//  Created by Jodi Smit on 4/14/23.
//

import Foundation
import UIKit

struct CurrentLocation {
    let latitude: String
    let longitude: String
}

struct CurrentWeatherObjectForView {
    var currentWeatherImage: UIImage?
    var currentLocation: String
    var currentHighLow: String
    var currentTemp: String
    var currentConditions: String
    var sunriseTime: String
    var windSpeed: String
    var humidity: String
}
