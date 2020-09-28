//
//  WeatherManager.swift
//  Clima
//
//  Created by Shawn Williams on 9/27/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager , weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    // Set Open Weather API URL
    let weatherURL: String = "https://api.openweathermap.org/data/2.5/weather?appid=8e643839c556d5f4034ed6045a26e695&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        // Get Users input and update create custom Open Weather URL with users location input
        let urlString = "\(self.weatherURL)&q=\(cityName)"
        // Start the action request
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String)  {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URL Session
            let session = URLSession(configuration: .default)
            //3. Give the sesssion a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    // Parse JSON Data
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
         do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
             return weather
         } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
