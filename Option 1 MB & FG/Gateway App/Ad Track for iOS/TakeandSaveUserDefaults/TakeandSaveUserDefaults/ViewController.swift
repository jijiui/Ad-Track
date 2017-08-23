//
//  ViewController.swift
//  TakeandSaveUserDefaults
//
//  Created by Wyat Da on 13/06/2017.
//  Copyright © 2017 Vtec. All rights reserved.
//


//Here I use Userdefault to save data for longterm. Compared to sQlite and plist,userdefaults dose not need to create documents,especially for small data


import UIKit

class ViewController: UIViewController {

    
    var majorValue_string = "0"{
    
        didSet{
            
            
        }
        
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func saveUserDefaults(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        //first check whether there is an object for the key, if nil, create one
        
        
        
        if (userDefaults.object(forKey: "Major") == nil)
        {
            getMajor()
            if(self.majorValue_string != "0"){
            var majorValue_int=Int(self.majorValue_string)
            userDefaults.set(majorValue_int,forKey:"Major")
        
            userDefaults.synchronize()
            }
        print("OK")
        }
        else
        {
            var a = userDefaults.integer(forKey: "Major")
            print(String(a))
        }
    
        
    }
    
    @IBAction func takeUserDefaults(_ sender: UIButton) {
        
        let userDefaults = UserDefaults.standard
        
        let Major = userDefaults.integer(forKey: "Major")
        print(Major)
        showDefaults.text = String(Major)
    }
    
    @IBOutlet weak var showDefaults: UITextView!
    
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
                    self.majorValue_string = (convertedJsonIntoDict["major"] as? String)!
                    print(self.majorValue_string)
                    
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

