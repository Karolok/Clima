//
//  WeatherManager.swift
//  Clima
//
//  Created by Karol Bryzgiel on 04/05/2020.
//  Copyright © 2020 Karol Bryzgiel. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=6d321d15a43acc35e0f14fe6024a255b&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(lat: Double, lon: Double) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //1. create a url
        if let url = URL(string: urlString) {
            //2. create a url session
            let urlSession = URLSession(configuration: .default)
            //3. give the session a task
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(weather)
                    }
                    
                }
            }
            //4. Start the task
            task.resume()
            
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel?
{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error)
            print(error)
            return nil
        }
        
    }
}
