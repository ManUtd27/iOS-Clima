//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    // Get an instance of the weather Manager
    var weatherManager = WeatherManager()
    // Get an instane of the Location Manager
    let locationManager = CLLocationManager()
    
    
    /// Handles logic for when the view appears
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the location manager delegate as self
        locationManager.delegate = self
        // As for permission to use the user location of the device. Must also be set in the info.plist
        locationManager.requestWhenInUseAuthorization()
        // Actulaly request location information from the device
        locationManager.requestLocation()
        // Set the weather manager delegate as self
        weatherManager.delegate = self
        // Set the search field delegate as self
        searchTextField.delegate = self
    }
   
}

//MARK:- UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    /// Handles logic for when the search button is pressed
    /// - Parameter sender: The UI component that send the request
    @IBAction func searchedPressed(_ sender: UIButton) {
        // Stops the editing process for the search field
        searchTextField.endEditing(true)
    }
    
    /// Delegate method that tells the textfield it should stop editing
    /// - Parameter textField: The text field
    /// - Returns: the status of the editing
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    /// Delegate methods that see's if the text field should stop editing
    /// - Parameter textField: the current textfield
    /// - Returns: the state of the textfield
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    /// The Delegate method that handles when the text field did stop editing
    /// - Parameter textField: The current text field
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Use search text field to get the weather for that city
        if let city = searchTextField.text {
            // Use the weathermanger instance with user input to fetch weather for city
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    /// Delegate method that handles the logic when data from the weather manager is updated
    /// - Parameters:
    ///   - weatherManager: The current weather manger instance
    ///   - weather: The shape of the weather data or model
    /// - Returns: returns void
    func didUpdateWeather(_ weatherManager: WeatherManager , weather: WeatherModel) -> Void {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
        
    }
    
    /// Delegate method that handles if the WeatherManger process did fail with error
    /// - Parameter error: The description of the current error
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    /// Hanles the logic when the user pressed the get current location button for weather data
    /// - Parameter sender: <#sender description#>
    @IBAction func locationPressed(_ sender: UIButton) {
        // Uses the location manager instance to get the current location
        locationManager.requestLocation()
    }
    
    /// Delegate method for getting the device location
    /// - Parameters:
    ///   - manager: The location manager instance with protocls
    ///   - locations: the location data for the device
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Set the location contanst to the last location of the device if available
        if let location = locations.last {
            // After to location data is catured stop updating location of the device
            locationManager.stopUpdatingLocation()
            // sets a const with the lat data from the location
            let lat = location.coordinate.latitude
            // Sets a const with the long data from the location
            let lon = location.coordinate.longitude
            // Use the Weather manager to fetch weather for the lat and long coords
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    /// Delegate method used to handle logic for any errors comming from the location manager
    /// - Parameters:
    ///   - manager: The location manager instance with protocols
    ///   - error: The description of the current error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
