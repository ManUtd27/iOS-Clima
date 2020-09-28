//
//  WeatherManager.swift
//  Clima
//
//  Created by Shawn Williams on 9/27/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL: String = "https://api.openweathermap.org/data/2.5/weather?appid=8e643839c556d5f4034ed6045a26e695&units=imperial"
    
    func fetchWeather(cityName: String){
        let urlString = "\(self.weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String)  {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URL Session
            let session = URLSession(configuration: .default)
            //3. Give the sesssion a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                }
            }
            //4. Start the task
            task.resume()
        }
    }
}
