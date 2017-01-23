//
//  ViewController.swift
//  ebayProgrammingExercise
//
//  Created by Brian Davis on 1/21/17.
//  Copyright © 2017 Brian Davis. All rights reserved.
//

import UIKit
import Foundation

class CountriesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var countriesArray: [Country] = []           //Global array of custom class Country used to populate table view
    var didParse = false                         //bool flag so that data is only parsed once
    @IBOutlet var tableViewOutlet: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getAndParseData()                           //call function to get and parse the data from API
        self.tableViewOutlet.reloadData()              //reload the table view once data is obtained
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CountryDetailSegue" {                                  //check for proper segue
            guard let indexPath = tableViewOutlet.indexPathForSelectedRow else {       //ensure we have index path
                return          //if no index path return out of function
            }
            /*create instance of destination view controller and sets the selected country variable to the country that was pressed*/
            let countryDetailViewController = segue.destination as! CountryDetailViewController
            countryDetailViewController.selectedCountry = self.countriesArray[indexPath.row]
            
            tableViewOutlet.deselectRow(at: indexPath, animated: true)
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countriesArray.count        //create as many rows as there are objects in the array
    }
    func tableView(_ tableView: UITableView, cellForRowAt: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countrycell", for: cellForRowAt) as UITableViewCell       //dequeue a cell
        cell.textLabel?.text = self.countriesArray[cellForRowAt.row].name     //get country name from countriesArray
        return cell
    }
    /***************************************************************************************************************
    ** getAndParseData() function creates a URL Session configures it with appropriate headers for authentication
    ** it then gets the data from API and parses the data into arguments used to call the Country initializer.
    ** That created object is then stored in our global countriesArray.
    ***************************************************************************************************************/
    func getAndParseData() {
        if (didParse) {         //if data has been parsed already return out of function
            return
        }
        else {
            let urlString = "https://restcountries-v1.p.mashape.com/all"
            
            if let url = URL(string: urlString) {
                let sessionConfig = URLSessionConfiguration.default
                /*Create and set headers array for authentication*/
                let headers = [
                    "X-Mashape-Key":"1IosQYQKu0mshuIZjcqiIXbiLGJSp1dBB9Yjsnfd2aISWLA7Yk",
                    "Accept":"application/json"
                ]
                sessionConfig.httpAdditionalHeaders = headers
                
                let urlSession = URLSession(configuration: sessionConfig)       //create URLSession and configure it
                urlSession.dataTask(with: url, completionHandler: { data, response, error in
                    if error == nil && data != nil {        //check for error and ensure data was returned
                        let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                        if let dataArray = json as? [Any] {         //get array of json data
                            var count: Int
                            var latitude: Double
                            var longitude: Double
                            for case let dataDict as [String: Any] in dataArray {     //get dictionary of json data
                                
                                /*reset variables for each countries set of data*/
                                count = 0
                                latitude = 0.0
                                longitude = 0.0
                                
                                /*get appropriate data from dictionary*/
                                if let name = dataDict["name"], let capital = dataDict["capital"], let coordinates = dataDict["latlng"], let population = dataDict["population"]{
                                    let area = dataDict["area"]
                                    if let latLongArray = coordinates as? [Any] {
                                        /*latLong comes back as array with latitudes in even locations and longitudes in odd so assign them thusly*/
                                        for latLong in latLongArray {
                                            if (count % 2 == 0) {
                                                latitude = latLong as! Double
                                                count += 1
                                            }
                                            else {
                                                longitude = latLong as! Double
                                            }
                                        }
                                    }
                                    /*create Country with appropriate arguments and store in countriesArray*/
                                    self.countriesArray.append(Country(name: name as! String, capital: capital as! String, population: population as! Int, area: area as? Double, latitude: latitude, longitude: longitude))
                                }
                            }
                        }
                        self.tableViewOutlet.reloadData()
                        self.didParse = true
                    }
                }).resume()
            }
            
        }
    }
}

