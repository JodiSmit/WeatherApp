//
//  ViewController.swift
//  WeatherApp
//
//  Created by Derrick Willer on 1/9/23.
//

import UIKit
import SDWebImage

class CurrentConditionsViewController: UIViewController {
    
    // MARK: - Intializers
    @IBOutlet weak var currentWeatherLargeImage: UIImageView!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var currentHighLow: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentConditions: UILabel!
    @IBOutlet weak var sunriseTime: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
    var viewModel: CurrentWeatherViewModel?
    
    // MARK: - View Load
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.delegate = self
    }
    
    // MARK: - Setup view
    
    func fillUI() {
        guard let viewModel = viewModel, let viewObject = viewModel.objectForView else {
            return
        }
        
        currentLocation.text = viewObject.currentLocation
        currentHighLow.text = viewObject.currentHighLow
        currentTemp.text = viewObject.currentTemp
        currentConditions.text = viewObject.currentConditions
        sunriseTime.text = viewObject.sunriseTime
        windSpeed.text = viewObject.windSpeed
        humidity.text = viewObject.humidity
    }
}


extension CurrentConditionsViewController: CurrentWeatherFetchDelegate {
    func weatherFetchCompleted() {
        DispatchQueue.main.async {
            self.fillUI()
        }
    }
    
    func imageFetchCompleted() {
        guard let viewModel = viewModel, let viewObject = viewModel.objectForView else {
            return
        }
        
        DispatchQueue.main.async {
            self.currentWeatherLargeImage.image = viewObject.currentWeatherImage
        }
    }
}
