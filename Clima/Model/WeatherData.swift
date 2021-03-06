//
//  WeatherData.swift
//  Clima
//
//  Created by Shawn Williams on 9/28/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

/// The structur of the weather data that is codable and used  for the shape for JSON decoding
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}
