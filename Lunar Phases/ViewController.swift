//
//  ViewController.swift
//  Lunar Phases
//
//  Created by block7 on 2/25/16.
//  Copyright © 2016 block7. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lunarPhaseImageView: UIImageView!
    @IBOutlet weak var dispLabel: UILabel!
    var currentlunarphase = ""
    var currentfracillum = ""
    var currentfracillumimage = ""
    
    func getDateString() -> String {
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        return "\(components.month)/\(components.day)/\(components.year)"
    
    }
    
    func getLunarData() {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://api.usno.navy.mil/rstt/oneday?date=\(getDateString())&loc=Boston,MA")!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
           
            do {
                self.currentfracillum = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)["fracillum"] as! String
                self.currentlunarphase = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)["curphase"] as! String
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.dispLabel.text = "\(self.currentfracillum) illumination, \(self.currentlunarphase)"
                    
                }
                
            } catch {
                let alert = UIAlertController(title: "you suck at coding", message: "you really really do", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: nil)
            }
    
        }
        
        task.resume()
    }
    
    
    func getSolarData() {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLunarData()
        getSolarData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

