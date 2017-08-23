//
//  ViewController.swift
//  getMajor
//
//  Created by Wyat Da on 14/06/2017.
//  Copyright © 2017 Vtec. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var ap="0"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    
    @IBAction func toget(_ sender: UIButton) {
       getMajor()
        print("dddddd")
       // print(ap)
        print("ap= ")
        var ab = Int(self.ap)
        print(ab)
    }
    
    
    
    
    
    func getMajor() {
        
        
        // Send HTTP GET Request
        
        let myUrl = NSURL(string: "https://m8ncryslai.execute-api.eu-central-1.amazonaws.com/test/major");
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        // If needed you could add Authorization header value
        // Add Basic Authorization
        
        // Or it could be a single Authorization Token value
        //request.addValue("Token token=884288bae150b9f2f68d8dc3a932071d", forHTTPHeaderField: "Authorization")
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            //var ap=responseString["major"]
            //print(ap)            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    // Get value by key
                    let majorValue = convertedJsonIntoDict["major"] as? String
                    print(majorValue!)
                    self.ap=majorValue!
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
       
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

