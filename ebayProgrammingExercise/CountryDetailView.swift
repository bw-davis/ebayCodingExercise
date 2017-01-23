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
    @IBOutlet var mapViewOutlet: MKMapView!
    
    /*The selected country created initially with default values but set in prior view controller's prepare for segue method*/
    var selectedCountry = Country(name: "", capital: "", population: 0, area: 0.0, latitude: 0.0, longitude: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pointAnnotation: MKPointAnnotation!
        var pinAnnotationView: MKPinAnnotationView!
        
        pointAnnotation = MKPointAnnotation()
        /*set coordinates of point annotation to the lat and long of selected country*/
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: self.selectedCountry.latitude, longitude: self.selectedCountry.longitude)
        pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
        mapViewOutlet.centerCoordinate = pointAnnotation.coordinate     //Center the view on the annotation
        
        var region: MKCoordinateRegion
        /*a few countries have nil for area in those cases I don't span out as far otherwise area is barely visible*/
        if let countryArea = self.selectedCountry.area {
            print(countryArea)
            region = MKCoordinateRegion(center: pointAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 11, longitudeDelta: 11))
        }
        else {
            region = MKCoordinateRegion(center: pointAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 5.5, longitudeDelta: 5.5))
        }
        
        self.mapViewOutlet.setRegion(region, animated: true)
        self.mapViewOutlet.addAnnotation(pinAnnotationView.annotation!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.title = "\(selectedCountry.name) Detail View"      //Set the title to Countries name
        nameLabelOutlet?.font = UIFont.boldSystemFont(ofSize: 17)              //Bold the label text
        /*Custom text using information about the country*/
        nameLabelOutlet?.text = "\(selectedCountry.name)'s population is \(NumberFormatter.localizedString(from: NSNumber(value: selectedCountry.population), number: NumberFormatter.Style.decimal)) and it's capital city is \(selectedCountry.capital)"
    }
}
