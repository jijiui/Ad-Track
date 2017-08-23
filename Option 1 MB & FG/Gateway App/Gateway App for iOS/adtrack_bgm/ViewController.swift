//
//  ViewController.swift
//  adtrack_bgm
//
//  Created by Wyat Da on 20/06/2017.
//  Copyright © 2017 Vtec. All rights reserved.
//

//For scanning iBeacon, the corelocation is needed while corebluetooth is not needed, little bit surprising

import UIKit
import CoreLocation

//var in= 0
//var timer: Timer?
class ViewController: UIViewController,CLLocationManagerDelegate {
    var locationManager:CLLocationManager = CLLocationManager()
    var city:String="jj"
    var timeStart:Double = 0.0
    var idfv = UIDevice.current.identifierForVendor?.uuidString
    var i=true
    var shouldILocate = true
    
    var userDefaultLanguage:String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTask), userInfo: nil, repeats: true)
        AudioManager.shared.openBackgroundAudioAutoPlay = true
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        let userDefaults = UserDefaults()
        userDefaults.set(["en"], forKey:"AppleLanguages")
        let uuid = UUID(uuidString:"A2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
        //let uuid = UUID(uuidString:"FDA50693-A4E2-4FB1-AFCF-C6EB07647825")!
        let region = CLBeaconRegion(proximityUUID: uuid, identifier: "iBeacon")
        locationManager.startRangingBeacons(in: region)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        
        guard let discoveredBeaconProximity = beacons.first?.proximity else {
            
            print("no beacon found");return
        }
        if shouldILocate{
            locationManager.startUpdatingLocation()
            
        }
        // print(beacons)
        var beacon:CLBeacon = beacons[beacons.count - 1]
        var majorVal = String(describing: beacon.major)
        print("rssi")
        print(beacon.rssi)
        nameForProximity(beacon.proximity,majorVal)
        //var pro = nameForProximity(beacon.proximity)
        print(beacon)
        
        print("the major is" + String(describing: majorVal))
        //print("the pro is "+pro)
        //var m = String(describing: majorVal)+pro
        
        //sendData(majorval:majorVal)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0{
            locationManager.stopUpdatingLocation()
            shouldILocate = false
            let location:CLLocation = locations[locations.count-1]
            var currLocation = locations.last!
            if(location.horizontalAccuracy>0){
                let geocoder:CLGeocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(currLocation){
                    
                    (placemark, error)->Void in
                    if(error==nil){
                        let array = placemark! as NSArray
                        let mark = array.firstObject as! CLPlacemark
                        self.city = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                        print(self.city)
                        
                    }
                }
            }
        }
    }
    
    
    func nameForProximity(_ proximity: CLProximity,_ major:String){
        
        
        switch proximity{
        case .unknown:
            print("Unknown")
            
        case .immediate:
            print("immediate")
            print(i)
            canISend(major)
        case .near:
            print(i)
            print("near")
            canISend(major)
        case .far:
            print("far")
            print(i)
            canISend(major)
        }
        
    }
    
    
    func canISend(_ major:String){
        var date = NSDate()
        if i{
            sendData(majorval:major)
            
            timeStart = date.timeIntervalSince1970
            i=false
            
        }
        else if((date.timeIntervalSince1970-timeStart>10)){
            print(date.timeIntervalSince1970-timeStart)
            sendData(majorval:major)
            timeStart = date.timeIntervalSince1970
            print(date.timeIntervalSince1970-timeStart)
        }
        
        
    }
    
    
    
    
    //    func timerTask() {
    //        in = in+1
    //        print(in)
    //    }
    
    
    
    func sendData(majorval:String){
        var dateandTime = getDateandTime()
        var request = URLRequest(url: URL(string: "https://m8ncryslai.execute-api.eu-central-1.amazonaws.com/test/viewers")!)
        print(request.url)
        request.httpMethod = "POST"
        let postString0 = "{\"operation\": \"create\",\"tableName\": \"Ad-track\",\"payload\": {\"Item\": {\"Date & Time\":\""+dateandTime+"\","
        let postString1 = "\"Mobile Phone ID\": \""+String(idfv!)
        let postString2="\",\"Advertisement Board ID\":\"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0 "+majorval+"\",\"City\":\""+city+"\"}}}"
        let postString = postString0+postString1+postString2
        //        let postString = "{\"operation\": \"create\",\"tableName\": \"Ad-track\",\"payload\": {\"Item\": {\"Date & Time\":\""+dateandTime+"\",\"Mobile Phone ID\":\"sad\"}}}"
        request.httpBody = postString.data(using: .utf8)
        //print(postString)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        
        task.resume()
    }
    
    func getDateandTime()->String{
        
        let now = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        var dateString=dformatter.string(from:now)
        print(dateString)
        return dateString
    }
    
    
    //change the music to silence before testing
    
}
