//
//  Country.swift
//  ebayProgrammingExercise
//
//  Created by Brian Davis on 1/21/17.
//  Copyright © 2017 Brian Davis. All rights reserved.
//

import Foundation

class Country {
    var name: String
    var capital: String
    var population: Int
    var latitude: Double
    var longitude: Double
    
    init(name:String, capital: String, population: Int, latitude: Double, longitude: Double){
        self.name = name
        self.capital = capital
        self.population = population
        self.latitude = latitude
        self.longitude = longitude
    }
}
