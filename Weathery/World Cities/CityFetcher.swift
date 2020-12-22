//
//  CityFetcher.swift
//  swiftuiSearchFilter
//
//  Created by Derek Hsieh on 12/20/20.
//

import Foundation

public class CityFetcher: ObservableObject {
    @Published var cities = [WorldCities]()
    
    init() {
        load()
    }
    
    func load() {
        let decoder = JSONDecoder()

        do {
            self.cities = try! decoder.decode([WorldCities].self, from: cityJson)
        }
    }
}
