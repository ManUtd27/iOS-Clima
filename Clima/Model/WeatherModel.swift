//
//  WeatherModel.swift
//  Clima
//
//  Created by Shawn Williams on 9/28/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

/// What our Weather data or model will look like
struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    // Computed property that returns a formatted string of the temperature
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    // Computed property that returns a condition name/SF symbol name based on the condition ID 
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
