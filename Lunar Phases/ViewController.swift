//
//  ViewController.swift
//  Lunar Phases
//
//  Created by block7 on 2/25/16.
//  Copyright © 2016 block7. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var lunarPhaseImageView: UIImageView!
    @IBOutlet weak var dispLabel: UILabel!
    @IBOutlet weak var dispLocation: UILabel!
    var currentlunarphase = ""
    var currentfracillum = ""
    var currentfracillumimage = ""
    var currenttemp = ""
    var locManager = CLLocationCoordinate2D()
    var locationManager = CLLocationManager()
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    var lat: Double = 0
    var lon: Double = 0
    var tempdata = ""
    
    func getDateString() -> String {
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        return "\(components.month)/\(components.day)/\(components.year)"
    
    }

   /* func getTime() {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        let hour = components.hour
        let minutes = components.minute
    } */
    
    
    func getLunarData() {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://api.usno.navy.mil/rstt/oneday?date=\(getDateString())&loc=Boston,MA")!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
           
            do {
                let no = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                print(try NSJSONSerialization.JSONObjectWithData(data!, options: []))
                self.currentfracillum = no["fracillum"] as! String
                self.currentlunarphase = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)["curphase"] as! String
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.dispLabel.text = "\(self.currentfracillum) illumination, \(self.currentlunarphase)"
                    
                }
                
            } catch {
                let alert = UIAlertController(title: "Error", message: "Can't get data", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
            }
    
        }
        
        task.resume()
    }
    
    
    func getLunarImage() {
         let request = NSMutableURLRequest(URL: NSURL(string: "http://api.usno.navy.mil/imagery/moon.png?&date=\(getDateString())&time=5:13")!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            let moonimage = UIImage(data: data!)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.lunarPhaseImageView.image = moonimage
            }
        }
        
        task.resume()
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.dispLocation.text = "Failed to retrieve you're location"
        print("Failed to find user's location: \(error.localizedDescription)")

    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            lat = locations[0].coordinate.latitude
            lon = locations[0].coordinate.longitude
            
            getWeatherData()
            
        } else {
            print("No locations")
        }
    }
    
    func getWeatherData() {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&APPID=82958a04ea128e90f026bf54f107e577")!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [.MutableContainers])
                let a = json.objectForKey("main")!
                let t = a["temp"] as! NSNumber
                
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.dispLocation.text = String(Int(round(Double(t) * (9.0/5.0) - 459.0))) + "°"
                }
            } catch {
                let alert = UIAlertController(title: "kikowaena loaa", message: "No wahi loaa", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
         task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLunarData()
        getLunarImage()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

