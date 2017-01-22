//
//  CountryDetailView.swift
//  ebayProgrammingExercise
//
//  Created by Brian Davis on 1/21/17.
//  Copyright © 2017 Brian Davis. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CountryDetailViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var nameLabelOutlet: UILabel?
    @IBOutlet var capitalLabelOutlet: UILabel?
    @IBOutlet var populationLabelOutlet: UILabel?
    @IBOutlet var mapViewOutlet: MKMapView!
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    var theCountry = Country(name: "", capital: "", population: 0, area: 0.0, latitude: 0.0, longitude: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let countryAnnotation = CountryAnnotation(title: self.theCountry.name, coordinate: CLLocationCoordinate2D(latitude: self.theCountry.latitude, longitude: self.theCountry.longitude), info: "The population is \(String(self.theCountry.population)) and it's capital city is \(self.theCountry.capital)")*/
        //mapViewOutlet.addAnnotation(countryAnnotation)
        
        
        
        self.pointAnnotation = MKPointAnnotation()
        
        self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: self.theCountry.latitude, longitude:     self.theCountry.longitude)
        
        
        self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
        
        self.mapViewOutlet.centerCoordinate = self.pointAnnotation.coordinate
        var region: MKCoordinateRegion
        if let countryArea = self.theCountry.area {
            //region = MKCoordinateRegionMakeWithDistance(
              //  self.pointAnnotation.coordinate, (countryArea/1.5), (countryArea/1.5))
            region = MKCoordinateRegion(center: self.pointAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15))
        }
        else {
            region = MKCoordinateRegion(center: self.pointAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 5.5, longitudeDelta: 5.5))
        }
        
        self.mapViewOutlet.setRegion(region, animated: true)
        self.mapViewOutlet.addAnnotation(self.pinAnnotationView.annotation!)
        
//        print(theCountry.name)
//        print(theCountry.capital)
//        print(theCountry.population)
//        print(theCountry.latitude)
//        print(theCountry.longitude)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.title = "\(theCountry.name) Detail View"
        nameLabelOutlet?.text = theCountry.name
        capitalLabelOutlet?.text = theCountry.capital
        populationLabelOutlet?.text = String(theCountry.population)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
