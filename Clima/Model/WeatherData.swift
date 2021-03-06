//
//  WeatherData.swift
//  Clima
//
//  Created by Karol Bryzgiel on 18/05/2020.
//  Copyright © 2020 Karol Bryzgiel. All rights reserved.
//

import Foundation

struct WeatherData : Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
}
