//
//  WeatherManager.swift
//  Clima
//
//  Created by Shawn Williams on 9/27/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL: String = "http://api.openweathermap.org/data/2.5/weather?appid=8e643839c556d5f4034ed6045a26e695&units=imperial"
    
    func fetchWeather(cityName: String){
        let urlString = "\(self.weatherURL)&q=\(cityName)"
        print(urlString)
    }
}
