//
//  MKPointAnnotation.swift
//  Notiee
//
//  Created by Jakub Kalamarz on 01/09/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    
// Return a distance from users location
func getUserDisance(from point: MKPointAnnotation) -> Double? {
    let userLocation = self.userLocation
    
    let pointLocation = CLLocation(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude)
    
    return userLocation.location?.distance(from: pointLocation)
}
}
