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
    
    var countriesArray: [Country] = []
    var latitude = 0.0
    var longitude = 0.0
    @IBOutlet var theTableView: UITableView!
    @IBAction func countryDetailDone(sender: UIStoryboardSegue) {
        // Intentionally left blank
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAndParseData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.theTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("Were here inside of the first function")
        return self.countriesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countrycell", for: cellForRowAt) as UITableViewCell
        //print("inside of the cell function")
        cell.textLabel?.text = self.countriesArray[cellForRowAt.row].name
        return cell
    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "" {
//            
//        }
//    }
    func getAndParseData() {
        let urlString = "https://restcountries-v1.p.mashape.com/all"
        
        if let url = URL(string: urlString) {
            let sessionConfig = URLSessionConfiguration.default
            let headers = [
                "X-Mashape-Key":"1IosQYQKu0mshuIZjcqiIXbiLGJSp1dBB9Yjsnfd2aISWLA7Yk",
                "Accept":"application/json"
            ]
            sessionConfig.httpAdditionalHeaders = headers
            
            let urlSession = URLSession(configuration: sessionConfig)
            urlSession.dataTask(with: url, completionHandler: { data, response, error in
                if error == nil && data != nil {
                    let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    if let dataArray = json as? [Any] {
                        for case let dataDict as [String: Any] in dataArray {
                            var count = 0
                            if let name = dataDict["name"], let capital = dataDict["capital"], let coordinates = dataDict["latlng"], let population = dataDict["population"]{
                                if let latLongArray = coordinates as? [Any] {
                                    for latLong in latLongArray {
                                        if (count % 2 == 0) {
                                            self.latitude = latLong as! Double
                                            count += 1
                                        }
                                        else {
                                            self.longitude = latLong as! Double
                                        }
                                    }
                                }
                                self.countriesArray.append(Country(name: name as! String, capital: capital as! String, population: population as! Int, latitude: self.latitude, longitude: self.longitude))
                            }
                        }
                    }
                    self.theTableView.reloadData()
                    print("The country array count is: ", self.countriesArray.count)
                    for country in self.countriesArray {
                        print(country.name)
                        print(country.capital)
                        print(country.population)
                        print(country.latitude)
                        print(country.longitude)
                    }
                }
            }).resume()
        }
    }
    
}

