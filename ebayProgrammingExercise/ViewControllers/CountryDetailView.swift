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
    /*create instances of the views needed for the populate controller*/
    var mapView = MKMapView()
    var innerView = UIView()
    var informationLabel = UILabel()
    /*The selected country created initially with default values but set in prior view controller's prepare for segue method*/
    var selectedCountry = Country(name: "", capital: "", population: 0, area: 0.0, latitude: 0.0, longitude: 0.0)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupLayout()       //call function that creates layout for controller
        createAndPlaceAnnotationOnMap()
        self.navigationItem.title = "\(selectedCountry.name)"      //Set the title to Countries name
        
    }
    
    /******************************************************************
    ** setupLayout() sets constraints for the controller using anchors
    ******************************************************************/
    func setupLayout() {
        
        /*set constraints for the MKMapView so that all 4 edges are equal to the edges of controller*/
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
    
        var leadingConstraint = mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        var trailingConstraint = mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        var topConstraint = mapView.topAnchor.constraint(equalTo: self.view.topAnchor)
        var bottomConstraint = mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
        
        /*set constraints for the view holding the label with country's information text*/
        innerView.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(innerView)
        
        leadingConstraint = innerView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20.0)
        trailingConstraint = innerView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20.0)
        topConstraint = innerView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 85.0)
        let heightConstraint = innerView.heightAnchor.constraint(equalToConstant: 128)
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, heightConstraint])
        
        /*set constraints for the country's information text label*/
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        innerView.addSubview(informationLabel)
        
        leadingConstraint = informationLabel.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 10.0)
        trailingConstraint = informationLabel.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -3.0)
        topConstraint = informationLabel.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 3.0)
        bottomConstraint = informationLabel.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: -3.0)
        informationLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.75)
        informationLabel.font = UIFont.boldSystemFont(ofSize: 17)      //Bold the label text
        
        let populationWithComma = NumberFormatter.localizedString(from: NSNumber(value: selectedCountry.population), number: NumberFormatter.Style.decimal)             //converts number format to decimal with commas
        
        /*Custom text using information about the country*/
        informationLabel.text = "\(selectedCountry.name)'s population is \(populationWithComma) and it's capital city is \(selectedCountry.capital)"
        informationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping     //allow for word wrapping
        informationLabel.numberOfLines = 2                                  //set number of text lines to 2
        informationLabel.textAlignment = NSTextAlignment.center             //align text to center
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
    /**********************************************************************************************
     ** createAndPlaceAnnotationOnMap() uses coordinates of the country to center the map on an 
     ** annotation placed at the coordinates and zooms out an appropriate amount to view country
     *********************************************************************************************/
    func createAndPlaceAnnotationOnMap() {
        
        var pointAnnotation: MKPointAnnotation!
        var pinAnnotationView: MKPinAnnotationView!
        
        /*set coordinates of point annotation to the lat and long of selected country*/
        pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: self.selectedCountry.latitude, longitude: self.selectedCountry.longitude)
        pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
        mapView.centerCoordinate = pointAnnotation.coordinate     //Center the view on the annotation
        
        var region: MKCoordinateRegion
        /*a few countries have nil for area in those cases I don't span out as far otherwise area is barely visible*/
        if let countryArea = self.selectedCountry.area {
            print(countryArea)
            region = MKCoordinateRegion(center: pointAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 11, longitudeDelta: 11))
        }
        else {
            region = MKCoordinateRegion(center: pointAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 5.5, longitudeDelta: 5.5))
        }
        
        self.mapView.setRegion(region, animated: true)
        self.mapView.addAnnotation(pinAnnotationView.annotation!)
    }
}
