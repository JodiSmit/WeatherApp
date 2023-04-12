//
//  CurrentWeatherViewModel.swift
//  WeatherApp
//
//  Created by Jodi Smit on 4/12/23.
//

import Foundation

//Struct for the current location object
struct CurrentLocation {
    let latitude: String
    let longitude: String
}

class CurrentWeatherViewModel {
    var weather: WeatherObject?
    var currentLocation: CurrentLocation
    let networkManager = NetworkManager.shared
    
    init() {
        currentLocation = CurrentLocation(latitude: "33.78591032377107", longitude: "-84.40964058633683")
        fetchCurrentWeather()
    }
    
    
    func fetchCurrentWeather() {
        Task.init {
            do {
                weather = try await networkManager.getData(from: APIEndpoints.getCurrentWeather(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
