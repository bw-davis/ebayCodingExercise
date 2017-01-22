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
    //var latitude = 0.0
    //var longitude = 0.0
    var didParse = false
    @IBOutlet var theTableView: UITableView!
    @IBAction func countryDetailDone(sender: UIStoryboardSegue) {
        // Intentionally left blank
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.theTableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getAndParseData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countriesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countrycell", for: cellForRowAt) as UITableViewCell
        cell.textLabel?.text = self.countriesArray[cellForRowAt.row].name
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CountryDetailSegue" {
            guard let indexPath = theTableView.indexPathForSelectedRow else {
                print("This didn't work")
                return
            }
            print(indexPath)
            print(self.countriesArray[indexPath.item].name)
            print(self.countriesArray[indexPath.item].capital)
            print(String(self.countriesArray[indexPath.row].population))
            let countryDetailViewController = segue.destination as! CountryDetailViewController
            countryDetailViewController.theCountry = self.countriesArray[indexPath.row]
            theTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    func getAndParseData() {
        if (didParse) {
            return
        }
        else {
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
                        print(json)
                        if let dataArray = json as? [Any] {
                            var count: Int
                            var latitude: Double
                            var longitude: Double
                            for case let dataDict as [String: Any] in dataArray {
                                count = 0
                                latitude = 0.0
                                longitude = 0.0
                                if let name = dataDict["name"], let capital = dataDict["capital"], let coordinates = dataDict["latlng"], let population = dataDict["population"]{
                                    let area = dataDict["area"]
                                    if let latLongArray = coordinates as? [Any] {
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
                                    self.countriesArray.append(Country(name: name as! String, capital: capital as! String, population: population as! Int, area: area as? Double, latitude: latitude, longitude: longitude))
                                }
                            }
                        }
                        self.theTableView.reloadData()
                        self.didParse = true
                        print("The country array count is: ", self.countriesArray.count)
                    }
                }).resume()
            }

        }
    }
    
}

