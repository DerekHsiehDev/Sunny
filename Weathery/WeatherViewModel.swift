//
//  WeatherViewModel.swift
//  Weathery
//
//  Created by Derek Hsieh on 12/23/20.
//

import SwiftUI
import Combine

class WeatherViewModel: ObservableObject {
    
    
    //    @Published var weatherViewModels = WeatherViewModel()
    @Published var currentWeather: WeatherData?
    @Published var currentTemp: Int?
    @Published var currentFeelsLike: Int?
    @Published var currentTempMax: Int?
    @Published var currentTempMin: Int?
    @Published var hourlyTemp: [Hourly]?
    @Published var timezone_offset: Int?
        
    var cityTemp: Int?
    
    private let url = "https://api.openweathermap.org/data/2.5/weather?appid=0ee7d97922c36d02d116dfbac3159fab&q="
    private var cancellable: AnyCancellable?
    private let oneUrl = "https://api.openweathermap.org/data/2.5/onecall?appid=0ee7d97922c36d02d116dfbac3159fab&lat="
    
    public func fetchWeather(city: String) {
        
        let safeCity = city.lowercased().filter("abcdefghigklmnopqrstuvwxyz+".contains)
        print(safeCity)

        let urlStr = URL(string: url + safeCity)
        
        cancellable = URLSession.shared.dataTaskPublisher(for: (urlStr)!)
            .receive(on: DispatchQueue.main)
            .sink { (_) in
                
            } receiveValue: { data, _ in
                if let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                    // Set weather
                    
                    self.currentWeather = weatherData
                    self.currentTemp = self.toFahrenheit(celsius: (self.toCelsius(kelvin: weatherData.main.temp)))
                    self.currentFeelsLike = self.toFahrenheit(celsius: (self.toCelsius(kelvin: weatherData.main.feels_like)))
                    self.currentTempMax = self.toFahrenheit(celsius: (self.toCelsius(kelvin: weatherData.main.temp_max)))
                    self.currentTempMin = self.toFahrenheit(celsius: (self.toCelsius(kelvin: weatherData.main.temp_min)))
                    self.cityTemp = self.toFahrenheit(celsius: (self.toCelsius(kelvin: weatherData.main.temp)))
                    //                    fetchHourlyWeather(lat: weatherData.coord.lat, long: weatherData.coord.long)
                    DispatchQueue.main.async {
                        self.fetchHourlyWeather(lat: String(weatherData.coord.lat ?? 0), long: String(weatherData.coord.long ?? 0))
                    }
                    
                    
                }
            }
        
    }
    
    public func fetchHourlyWeather(lat: String, long: String) {
        let urlStr = URL(string: oneUrl + "\(lat)&lon=\(long)&exclude=current,minutely,daily,alerts")
        
        cancellable = URLSession.shared.dataTaskPublisher(for: (urlStr)!)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (_) in
                
            }, receiveValue: { data, _ in
                
                
                if let hourlyWeather = try? JSONDecoder().decode(HourlyWeatherData.self, from: data) {
                    
                    self.timezone_offset = hourlyWeather.timezone_offset
                    
                    for weather in hourlyWeather.hourly {
                        
                        self.hourlyTemp?.append(weather)
                        
                    }
                    
           
                }
                
              
            })
        
    }
    
    
//    public func fetchOneCityWeather(city: String) -> Int {
//        var temp = -1
//
//        let safeCity = city.lowercased().filter("abcdefghigklmnopqrstuvwxyz+".contains)
//
//        let urlStr = URL(string: url + safeCity)
//
//        cancellable = URLSession.shared.dataTaskPublisher(for: (urlStr)!)
//            .receive(on: DispatchQueue.main)
//            .sink { (_) in
//
//            } receiveValue: { data, _ in
//                if let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
//
//                    // Set weather
//                    temp = self.toFahrenheit(celsius: (self.toCelsius(kelvin: weatherData.main.temp)))
//                }
//            }
//
//        return temp
//
//    }
    
    
    func toCelsius(kelvin: Double) -> Double {
        
        
        let celsius = (kelvin - 273.15)
        return (celsius)
        
    }
    
    func toFahrenheit(celsius: Double) -> Int{
        let fahrenheit = celsius * 9 / 5 + 32
        return Int(fahrenheit)
        
    }
    
    
    
}




