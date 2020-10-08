//
//  WeatherManager.swift
//  Clima
//
//  Created by Shawn Williams on 9/27/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation


/// A protocall used to contract any who impleements the Weathermanager Delegate
protocol WeatherManagerDelegate {
    // Stub of how the didupdate weather should look like with method signatures
    func didUpdateWeather(_ weatherManager: WeatherManager , weather: WeatherModel)
    // Stub of how the did fail with error weather should look like with method signatures
    func didFailWithError(error: Error)
}

/// The Weather manager sturcture
struct WeatherManager {
    // Set Open Weather API URL
    let weatherURL: String = "https://api.openweathermap.org/data/2.5/weather?appid={YOUR API KEY}&units=imperial"
    
    // Sets the data type of the delegate
    var delegate: WeatherManagerDelegate?
    
    /// Used to get users input for the city name and create the approipiate URL to start the request
    /// - Parameter cityName: <#cityName description#>
    func fetchWeather(cityName: String){
        // Get Users input and update create custom Open Weather URL with users location input
        let urlString = "\(self.weatherURL)&q=\(cityName)"
        // Start the action request
        performRequest(with: urlString)
    }
    
    /// Used to get the device location and create the approipaite URL to start the request
    /// - Parameters:
    ///   - latitude: The lat of the device
    ///   - longitude: The long of the device
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        // Get Users input and update create custom Open Weather URL with users location input
        let urlString = "\(self.weatherURL)&lat=\(latitude)&lon=\(longitude)"
        // Start the action request
        performRequest(with: urlString)
    }
    
    /// Handles the API request with url for weather data
    /// - Parameter urlString: the created url string with user input for weather data using the API
    func performRequest(with urlString: String)  {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URL Session
            let session = URLSession(configuration: .default)
            //3. Give the sesssion a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    //if there was an error use the delegate to have the implementers call their did fail with error methods
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                // Safely unwrap the data returned from the api request
                if let safeData = data {
                    // Parse JSON Data and set the weather constand to the results
                    if let weather = self.parseJSON(safeData) {
                        //use the delegate to have the implementers call their did update weather methods with the current weather data
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    /// Used to parse and decode the JSON data retured from the api request
    /// - Parameter weatherData: The safe JSON data passed by calling api request
    /// - Returns: Returns the correclty decoded Formate to use in the app
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        // Get a instance of the JSON decoder
        let decoder = JSONDecoder()
        // Wrap the docode process in a do / catch block to handle any errors
         do {
            //Try and decode the JSON data with The Weather Data structor we want and set the decoded data to a constant
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            // Get the id from the decoded data and set to a const
            let id = decodedData.weather[0].id
            // Get the temp from the decoded data and set to a const
            let temp = decodedData.main.temp
            // Get the name from the decoded data and set to a const
            let name = decodedData.name
            // create a weather instance using the Weather model passing it the created const
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            // return the instance of the newly created weather object
             return weather
         } catch {
            // Catches any erros thrown by the do block and the try decode statement then uses the deleagte to tell the implementers to use their fail methods to handle error
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
