//
//  WeatherData.swift
//  Weathery
//
//  Created by Derek Hsieh on 12/23/20.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    
    let main: Main
    
    let wind: Wind
    
    let weather: [Weather]
}



struct Weather: Decodable {
    let description: String
    let id: Int
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max : Double
    let humidity: Int
}

struct Wind: Decodable {
    let speed: Double
}

