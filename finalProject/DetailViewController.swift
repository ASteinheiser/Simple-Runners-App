//
//  DetailViewController.swift
//  finalProject
//
//  Created by Andrew Steinheiser on 11/15/16.
//  Copyright © 2016 AndrewSteinheiser. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var runName: UITextField!
    @IBOutlet weak var runAddress: UITextField!
    @IBOutlet weak var runDesc: UITextView!
    @IBOutlet weak var runMap: MKMapView!
    @IBOutlet weak var runWeather: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var runTemp: UILabel!
    
    var selectedName = String()
    var selectedDesc = String()
    var selectedAddress = String()
    
    var newRun = run?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runName.text = selectedName
        runDesc.text = selectedDesc
        runAddress.text = selectedAddress
        
        self.runName.layer.borderWidth = 1.0;
        self.runName.layer.borderColor = UIColor.lightGrayColor().CGColor;
        self.runName.layer.cornerRadius = 8;
        self.runDesc.layer.borderWidth = 1.0;
        self.runDesc.layer.borderColor = UIColor.lightGrayColor().CGColor;
        self.runDesc.layer.cornerRadius = 8;
        self.runAddress.layer.borderWidth = 1.0;
        self.runAddress.layer.borderColor = UIColor.lightGrayColor().CGColor;
        self.runAddress.layer.cornerRadius = 8;
        
        let geocoder = CLGeocoder()
        var coordinates:CLLocationCoordinate2D?
        
        geocoder.geocodeAddressString(self.runAddress.text!, completionHandler:{(placemarks, error) -> Void in
            if (error != nil) {
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                coordinates = placemark.location!.coordinate
                let initialLocation = CLLocation(latitude: (coordinates?.latitude)!, longitude:(coordinates?.longitude)!)
                self.centerMapOnLocation(initialLocation)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates!
                annotation.title = self.selectedName
                self.runMap.addAnnotation(annotation)
                
                self.getTemp((coordinates?.latitude)!, longitude: (coordinates?.longitude)!)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        runMap.setRegion(coordinateRegion, animated: true)
    }
    
    func getTemp(latitude: Double, longitude: Double) {
        let path = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=imperial&appid=c75d61cc190e1eb6886a022b64977d9b"
        let url = NSURL(string: path)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
                let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                
                if json != nil {
                    if let weather = json!["weather"] as? NSArray {
                        if let desc = weather[0]["description"] as? String {
                            self.runWeather.text = desc
                        }
                    }
                    if let main = json!["main"] as? NSDictionary {
                        if let temp = main["temp"] as? Double {
                            self.runTemp.text = String(format: "%.0f", temp) + " and"
                        }
                    }
                }
            })
        }
        task.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            self.newRun = run(n: self.runName.text!, d: self.runDesc.text!, a: self.runAddress.text!)
        }
    }
}
