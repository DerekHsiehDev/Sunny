//
//  WeatherService.swift
//  Weathery
//
//  Created by Derek Hsieh on 12/24/20.
//

import Foundation
import Combine

final class WeatherService {
    
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=0ee7d97922c36d02d116dfbac3159fab&q="
 
    func fetchweather(city: String) -> AnyPublisher<WeatherDataContainer, Error> {
        
        let newCity = city.filter("abcdefghigklmnopqrstuvwxyz".contains)
        let urlString = URL(string: url + newCity)
        
        return URLSession.shared.dataTaskPublisher(for: urlString!)
            .map { $0.data }
            .decode(type: WeatherDataContainer.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    

}


struct WeatherDataContainer: Decodable{
    
    let name: String
    
    let main: Main
    
}

//struct Main: Decodable {
//    let temp: Double
//    let feels_like: Double
//    let temp_min: Double
//    let temp_max : Double
//}

