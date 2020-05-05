//
//  LocationViewModel.swift
//  FavouriteThings
//
//  Created by Jake Attard on 6/5/20.
//  Copyright © 2020 Jake Attard. All rights reserved.
//

import Foundation
import CoreLocation

class Place: Identifiable, ObservableObject {
    @Published var coordinates = CLLocationCoordinate2D(latitude: -27.962, longitude: 153.382)
    
    var name = ""
    
    var latitude: String {
        get { "\(coordinates.latitude)" }
        set {
            guard let coord = CLLocationDegrees(newValue) else { return }
            coordinates.latitude = coord
        }
    }
    
    var longitude: String {
        get { "\(coordinates.longitude)" }
        set {
            guard let coord = CLLocationDegrees(newValue) else { return }
            coordinates.longitude = coord
        }
    }
    
    func updateCoordinatesFromName() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { (maybePlaceMarks, maybeError) in
            guard let placemark = maybePlaceMarks?.first,
            let location = placemark.location else {
                let description: String
                if let error = maybeError {
                    description = "\(error)"
                } else {
                    description = "<Unkown Error>"
                }
                
                print("Got an error: \(description)")
                return
            }
            
            self.coordinates = location.coordinate
        }
    }
}
