//
//  WeatherVC.swift
//  ClimaApp
//
//  Created by baotuan on 10/31/17.
//  Copyright © 2017 baotuan. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherVC: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //MARK: Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    //MARK: Local variables
    let locationManager = CLLocationManager()
    
    //MARK: UIView control
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    //MARK: Model
    let weatherDataModel = WeatherDataModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UI Action
    
    @IBAction func changeLocationPress(_ sender: Any) {
        self.performSegue(withIdentifier: "goToChangeLocation", sender: self)
    }
    
    //MARK: Networking
    
    func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess{
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
                
            }
        }
    }
    
    func updateWeatherData(json : JSON) {
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperture = Int(tempResult - 272.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUI()
        } else {
            cityLabel.text = "Weather Unavailable"
        }
        
    }
    
    func updateUI() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperture)℃"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    //MARK: Location Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            
            let params : [String : String] = ["lat": latitude, "lon": longitude, "appid": APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    //MARK: Receive data from delegate
    func userChangeANewCity(city: String) {
        let params : [String: String] = ["q": city, "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    //Config segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChangeLocation" {
            let destinationVC = segue.destination as! ChangeCityLocationVC
            destinationVC.delegate = self
        }
    }
    

}
