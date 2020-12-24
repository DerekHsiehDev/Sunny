//
//  WeatherViewModel.swift
//  Weathery
//
//  Created by Derek Hsieh on 12/23/20.
//

import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var temp: Int = 0
    @Published var feels_like: Int = 0
    
    func setTemp(temp: Int) {
        self.temp = temp
    }
}
