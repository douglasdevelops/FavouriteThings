//
//  FormulaOneDriverViewDelegate.swift
//  FavouriteThings
//
//  Created by Jake Attard on 13/5/20.
//  Copyright © 2020 Jake Attard. All rights reserved.
//

import CoreData
import SwiftUI
import CoreLocation
import MapKit

class FormulaOneDriverMapViewDelegate: NSObject, Identifiable, ObservableObject {
    
    /// variable formulaOneDriver calling the FormulaOneDriver class
    @ObservedObject var formulaOneDriver: FormulaOneDriver
    
    /// Declaring new variable called latitudeTextCoord which is a string
    var latitudeTextCoord: String
    
    /// Declaring new variable called longitudeTextCoord which is a string
    var longitudeTextCoord: String
    
    /// Initialising the FormulaOneDriver class, latitudeTextCorrd with the formulaOneDriverLatitude and longitudeTextCoord with the formulaOneDriverLongitude
    init(formulaOneDriver: FormulaOneDriver) {
        self.formulaOneDriver = formulaOneDriver
        self.latitudeTextCoord = formulaOneDriver.formulaOneDriverLatitude
        self.longitudeTextCoord = formulaOneDriver.formulaOneDriverLongitude
    }
    
    /// getMapCoords function gets the coordinates from the model and puts it into the latitude and longitude variables
    func getMapCoords() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: formulaOneDriver.latitude, longitude: formulaOneDriver.longitude)
    }
    
    /// setMapCoords function sets the longitude and latitude variable to the FormulaOneDriver object
    func setMapCoords(newCoords: CLLocationCoordinate2D) {
        formulaOneDriver.formulaOneDriverLongitude = "\(newCoords.longitude)"
        formulaOneDriver.formulaOneDriverLatitude = "\(newCoords.latitude)"
    }
    
    /// setMapCoords function sets the longitude and latitude variable to the FormulaOneDriver object
    func setMapCoords(latitude: String, longitude: String) {
        formulaOneDriver.formulaOneDriverLatitude = latitude
        formulaOneDriver.formulaOneDriverLongitude = longitude
    }
    
    /// updateCoordinatesFromName function updates the coordinates once locationName has been added to the TextField
    func updateCoordinatesFromName() {
        /// Reverse and forward geocoding for the locationName and coordinates
        let geocoder = CLGeocoder()
        /// The location latitude and longitude coordinates is returned from the locationName
        geocoder.geocodeAddressString(formulaOneDriver.formulaOneDriverLocationName) { (maybePlaceMarks, maybeError) in
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
            
            /// Getting the mapCoordinates
            self.setMapCoords(newCoords: location.coordinate)
        }
    }
    
    
    /// updateNameFromCoordinates updates the locationName once the coordinates have been entered
    func updateNameFromCoordinates() {
        /// Updates when the locationName textfield is empty else it just updates the map coordinates
        guard formulaOneDriver.formulaOneDriverLocationName == "" else { setMapCoords(latitude: latitudeTextCoord, longitude: longitudeTextCoord);return}
        
        setMapCoords(latitude: latitudeTextCoord, longitude: longitudeTextCoord)
        
        /// Reverse and forward geocoding for the locationName and coordinates
        let geocoder = CLGeocoder()
        
        /// location variable is storing the locationName from coordinates
        let location = CLLocation(latitude: formulaOneDriver.latitude, longitude: formulaOneDriver.longitude)
        
        /// Returns the location based on the longitude and latitude
        geocoder.reverseGeocodeLocation(location) { (maybePlaceMarks, maybeError) in
            guard let placemark = maybePlaceMarks?.first else {
                let description: String
                if let error = maybeError {
                    description = "\(error)"
                } else {
                    description = "<Unkown Error>"
                }
                
                print("Got an error: \(description)")
                return
            }
            /// Getting the locationName
            self.formulaOneDriver.formulaOneDriverLocationName = placemark.name ?? placemark.administrativeArea ?? placemark.locality ?? placemark.subLocality ?? placemark.thoroughfare ?? placemark.subThoroughfare ?? placemark.country ?? "<Unkown Location Name>"
        }
    }
}
