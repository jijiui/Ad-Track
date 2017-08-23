//
//  ViewController.swift
//  try2
//
//  Created by Wyat Da on 16/06/2017.
//  Copyright © 2017 Vtec. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController,CBPeripheralManagerDelegate {
//var peripheralManager: CBPeripheralManager!
    var peripheralManager: CBPeripheralManager!
    var userDefaults = UserDefaults.standard
    var isShowingVTECInfo = false
    
    let button:UIButton = UIButton(type:.system)
    
 
    
    
    
    
    
    var majorValue_string = "initializing"{
    
    
        didSet{
            self.userDefaults.set(majorValue_string,forKey:"Major")
          userDefaults.synchronize()
            print("OK")
            advertiseDevice(region : createBeaconRegion(CLBeaconMajorValue(majorValue_string)!))
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       //AudioManager.shared.openBackgroundAudioAutoPlay = true
        
        
        
        button.frame = CGRect(x:30, y:350, width:100,height:30)
        button.center.x = self.view.bounds.width/2
        button.setTitle("About Us", for: .normal)
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(About_Us(_:)), for: .touchUpInside)
    
        peripheralManager = CBPeripheralManager(delegate:self,queue:nil)
        
    }

    func peripheralManagerDidUpdateState(_ peripheral:CBPeripheralManager){
        print("state:\(peripheral.state)")
        switch (peripheral.state) {
        case CBManagerState.poweredOn:
            //monitoringBluetoothStatus.text="Bluetooth Status: ON"
            print("onn")
            bluetoothStatus.text = "Bluetooth Status: ON"
            bluetoothStatus.textColor = UIColor.white
            
            let a = CBPeripheralManager.authorizationStatus()
            switch a {
                
            case .authorized:
                print("ok")
                if (userDefaults.object(forKey: "Major") == nil){
                    
                    getMajor()
                    
                    
                }
                else{
                    advertiseDevice(region : createBeaconRegion(CLBeaconMajorValue(userDefaults.string(forKey: "Major")!)!))
                }
                

                
            default:
                print("no")
            }
        case CBManagerState.poweredOff:
            //monitoringBluetoothStatus.text="Bluetooth Status: OFF"
            print("off")
            bluetoothStatus.text = "Bluetooth Status: OFF"
            bluetoothStatus.textColor = UIColor.red
        default:
            print("unknown")
        }
        //let advertisementData = [CBAdvertisementDataLocalNameKey: "TestDevice"]
        //peripheralManager.startAdvertising(advertisementData)
            }
    func createBeaconRegion(_ majorValue:CLBeaconMajorValue) -> CLBeaconRegion{
        let proximityUUID = UUID(uuidString:
            "39ED98FF-2900-441A-802F-9C398FC199D2")
        //check whether there is major already
        //let userDefaults = UserDefaults.standard
                       
        let major : CLBeaconMajorValue = majorValue
        print(major)
        //let major : CLBeaconMajorValue = 100
        
        let minor : CLBeaconMinorValue = 1
        let beaconID = "com.example.myDeviceRegion"
        
        return CLBeaconRegion(proximityUUID: proximityUUID!,
                              major: major, minor: minor, identifier: beaconID)
    }

    
    func advertiseDevice(region : CLBeaconRegion) {
        
        let peripheralData = region.peripheralData(withMeasuredPower: nil)
        
        peripheralManager.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
//        print(peripheralData.address)
//        print(peripheral.)
    }

    
    func peripheralManagerDidStartAdvertising(_ peripheral:CBPeripheralManager,error:NSError?){
        if let error = error{
            print("error:\(error)")
            return
        }
        print("succceed")
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
                    self.majorValue_string = (convertedJsonIntoDict["major"] as? String)!
                    
                    
                    print(self.majorValue_string)
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
    }
    
    
    
    
    
    
    
    @IBOutlet weak var showing: UITextView!
    
    
    @IBOutlet weak var bluetoothStatus: UITextView!
    
    
    @IBAction func gotoSettings(_ sender: UIButton) {
        
        
        let url = URL(string: UIApplicationOpenSettingsURLString)
        
        if let url = url, UIApplication.shared.canOpenURL(url){
            
            if #available(iOS 10, *){
                
                
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    
                    (success) in
                })
                
                
            }else{
                
                UIApplication.shared.openURL(url)
                
                
            }
            
            
        }
        
        
    }
    
    @IBAction func About_Us(_ sender: UIButton) {
        if(isShowingVTECInfo){
            
            showing.text = "Thanks for Using Ad Track!\n\nPleas turn on Bluetooth.\nIf you did not allow Ad Track to access Bluetooth, please permit in Settings and go back to Ad Track"
            
            isShowingVTECInfo = false
            button.setTitle("About Us", for: .normal)
        }else{
            
            
            showing.text = "VTEC Lasers & Sensors\nKastanjelaan 400\n5616 LZ\nEindhoven\nThe Netherlands\nmail: info@vtec-ls.nl"
            //About_Us.setTitle("dsa", for:.nomal)
            isShowingVTECInfo = true
            
            button.setTitle("Back", for: .normal)
        }
    }

    

    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

