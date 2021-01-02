//
//  WeatherData.swift
//  Weathery
//
//  Created by Derek Hsieh on 12/23/20.
//

import Foundation
import SwiftUI

struct WeatherData: Decodable {
    
    let name: String
    
    let main: Main
    
    let wind: Wind
    
    let weather: [Weather]
    
    let coord: Coord
}

struct Coord: Decodable {
    let lon: Double?
    let lat: Double?
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

struct HourlyWeatherData: Decodable {
    let hourly: [Hourly]
    let timezone_offset: Int
    let daily: [Daily]
}

struct Daily: Decodable, Hashable {
    
    let dt: Int
    
    let temp: Temp
    
    let weather: [DailyWeather]

}

struct DailyWeather: Decodable, Hashable {
    let id: Int
}

struct Temp: Decodable, Hashable {
    let min: Double
    let max: Double
}

struct Hourly: Decodable, Hashable {
 
    let dt: Int
    let temp: Double
}

