//
//  CurrentWeatherViewModel.swift
//  WeatherApp
//
//  Created by Jodi Smit on 4/12/23.
//

import Foundation
import UIKit
import SDWebImage

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
    var objectForView: CurrentWeatherObjectForView?
    
    init(currentLocation: CurrentLocation = CurrentLocation(latitude: "33.78591032377107", longitude: "-84.40964058633683")) {
        self.gozioLocation = currentLocation
        fetchCurrentWeather()
    }
    
    func fetchCurrentWeather() {
        Task.init {
            do {
                weather = try await networkManager.getData(from: APIEndpoints.getCurrentWeather(latitude: gozioLocation.latitude, longitude: gozioLocation.longitude))
                if let currentWeatherImageURL = URL(string: APIHelper.baseImageURL + "/img/wn/\(weather?.weather.first?.icon ?? "10d")@2x.png") {
                    self.fetchImage(for: currentWeatherImageURL)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func formatObjectForView() {
        objectForView = CurrentWeatherObjectForView(currentLocation: weather?.name ?? "Location", currentHighLow: highLowForView(), currentTemp: currentTempForView(), currentConditions: currentConditionForView(), sunriseTime: sunriseTimeForView(), windSpeed: windSpeedForView(), humidity: humidityForView())
        delegate?.weatherFetchCompleted()
    }
    
    func fetchImage(for url: URL) {
        SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { [weak self] (image, _, _, _, _, _) in
            self?.objectForView?.currentWeatherImage = image
            self?.delegate?.imageFetchCompleted()
        }
    }
}

extension CurrentWeatherViewModel {
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
