//
//  TodayViewController.swift
//  Lunar Phases Today Widget
//
//  Created by block7 on 3/11/16.
//  Copyright © 2016 block7. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var dispLabel: UILabel!
    
    var currentlunarphase = ""
    var currentfracillum = ""
    
    
    
    
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

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        var currentSize: CGSize = self.preferredContentSize
        currentSize.height = 200.0
        self.preferredContentSize = currentSize
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
