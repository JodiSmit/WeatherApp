//
//  CurrentWeatherViewModel.swift
//  WeatherApp
//
//  Created by Jodi Smit on 4/12/23.
//

import Foundation
import UIKit
import SDWebImage

struct CurrentLocation {
    let latitude: String
    let longitude: String
}

protocol CurrentWeatherFetchDelegate: AnyObject {
    func weatherFetchCompleted()
    func imageFetchCompleted()
}

class CurrentWeatherViewModel {
    weak var delegate: CurrentWeatherFetchDelegate?
    
    var weather: WeatherObject? {
        didSet {
            formatObjectForView()
        }
    }
    var gozioLocation: CurrentLocation
    let networkManager = NetworkManager.shared
    var currentWeatherImage: UIImage?
    var currentLocation: String?
    var currentHighLow: String?
    var currentTemp: String?
    var currentConditions: String?
    var sunriseTime: String?
    var windSpeed: String?
    var humidity: String?
    
    init() {
        gozioLocation = CurrentLocation(latitude: "33.78591032377107", longitude: "-84.40964058633683")
        fetchCurrentWeather()
    }
    
    func fetchCurrentWeather() {
        var request: URLRequest?
        do {
            request = try networkManager.createRequest(from: APIEndpoints.getCurrentWeather(latitude: gozioLocation.latitude, longitude: gozioLocation.longitude))
        }
        catch let error {
            print("Error: \(error)")
        }
        guard let url = request?.url else { return }
        
        networkManager.makeRequest(with: url, httpMethod: "GET", requestBody: nil) { (result: Result<WeatherObject, Error>) in
            switch result {
            case .success(let weather):
                self.weather = weather
                if let currentWeatherImageURL = URL(string: APIHelper.baseImageURL + "/img/wn/\(weather.weather.first?.icon ?? "10d")@2x.png") {
                    self.fetchImage(for: currentWeatherImageURL)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func formatObjectForView() {
        currentLocation = weather?.name
        currentHighLow = highLowForView()
        currentTemp = currentTempForView()
        currentConditions = currentConditionForView()
        sunriseTime = sunriseTimeForView()
        windSpeed = windSpeedForView()
        humidity = humidityForView()
        delegate?.weatherFetchCompleted()
    }
    
    func fetchImage(for url: URL) {
        SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { [weak self] (image, _, _, _, _, _) in
            self?.currentWeatherImage = image
            self?.delegate?.imageFetchCompleted()
        }
    }
    
    func highLowForView() -> String {
        guard let max = weather?.main.tempMax, let min = weather?.main.tempMin else { return "" }
        return "H \(Int(max.rounded(.toNearestOrAwayFromZero)))ºF / L \(Int(min.rounded(.toNearestOrAwayFromZero)))ºF"
    }
    
    func currentTempForView() -> String {
        guard let temp = weather?.main.temp else { return "--" }
        return "\(Int(temp.rounded(.toNearestOrAwayFromZero)))"
    }
    
    func currentConditionForView() -> String {
        guard let condition = weather?.weather.first?.main else { return "" }
        return condition
    }
    
    func sunriseTimeForView() -> String {
        guard let time = weather?.sys.sunrise else { return "" }
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let formattedTime = formatter.string(from: date).lowercased().replacingOccurrences(of: " am", with: "")
        return formattedTime
    }
    
    func windSpeedForView() -> String {
        guard let wind = weather?.wind.speed else { return "" }
        return "\(Int(wind.rounded(.toNearestOrAwayFromZero))) m/h"
    }
    
    func humidityForView() -> String {
        guard let humidity = weather?.main.humidity else { return "" }
        return "\(humidity)%"
    }
}
