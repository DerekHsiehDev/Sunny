//
//  LocationManager.swift
//  Weathery
//
//  Created by Derek Hsieh on 1/1/21.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManger = CLLocationManager()
    @Published var location: CLLocation? = nil
    
    override init() {
        super.init()
        self.locationManger.delegate = self
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManger.distanceFilter = kCLDistanceFilterNone
        self.locationManger.requestWhenInUseAuthorization()
        self.locationManger.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        self.location = location
    }
    
}
