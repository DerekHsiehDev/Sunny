////
////  WeatherModel.swift
////  Weathery
////
////  Created by Derek Hsieh on 12/23/20.
////
//
//import Foundation
//import SwiftUI
//
//class WeatherModel {
//
//    @ObservedObject var viewModel = WeatherViewModel()
//
//    let url = "https://api.openweathermap.org/data/2.5/weather?appid=0ee7d97922c36d02d116dfbac3159fab&q="
//
//    func getOneTimeWeather(city: String) {
//
//        if let urlString = URL(string: url + city) {
//            let session = URLSession(configuration: .default)
//
//            let task = session.dataTask(with: urlString) { (data, response, error) in
//                self.handle(data: data, response: response, error: error)
//            }
//
//            task.resume()
//        }
//
//
//    }
//
//    func handle(data: Data?, response: URLResponse?, error: Error?) {
//        if error != nil {
//            print(error!)
//            return
//        }
//
//        if let safeData = data {
////            let dataString = String(data: safeData, encoding: .utf8 )
////            print(dataString!)
//            self.parseJSON(weatherData: safeData)
//        }
//    }
//
//    func parseJSON(weatherData: Data) {
//        let decoder = JSONDecoder()
//        do {
//            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
//
//
//            viewModel.temp = toFahrenheit(celsius: (toCelsius(kelvin: decodedData.main.temp)))
//
//
//            print(toFahrenheit(celsius: (toCelsius(kelvin: decodedData.main.temp))))
//            viewModel.feels_like = toFahrenheit(celsius: (toCelsius(kelvin: decodedData.main.feels_like)))
//        } catch {
//            print(error)
//        }
//    }
//

//}
