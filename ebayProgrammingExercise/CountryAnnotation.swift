//
//  CountryAnnotation.swift
//  ebayProgrammingExercise
//
//  Created by Brian Davis on 1/22/17.
//  Copyright © 2017 Brian Davis. All rights reserved.
//

import MapKit
import UIKit

class CountryAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
