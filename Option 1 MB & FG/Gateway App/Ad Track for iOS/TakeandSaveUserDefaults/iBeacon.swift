//
//  iBeacon.swift
//  TakeandSaveUserDefaults
//  Created by Wyat Da on 16/06/2017.
//  Copyright © 2017 Vtec. All rights reserved.
//

import Foundation
import CoreLocation
import CoreBluetooth

class iBeacon {
    
    var major = 0{
        didSet{
        
            
            
        }
    
    }
    var peripheralManager: CBPeripheralManager!
    
    
    func peripheralManagerDidUpdateState(_ peripheral:CBPeripheralManager){
        print("state:\(peripheral.state)")
        //let advertisementData = [CBAdvertisementDataLocalNameKey: "TestDevice"]
        //peripheralManager.startAdvertising(advertisementData)
        //self.advertiseDevice(region : self.createBeaconRegion(self.major))
        
    }

    func createBeaconRegion(_ majorValue:Int) -> CLBeaconRegion{
        let proximityUUID = UUID(uuidString:
            "39ED98FF-2900-441A-802F-9C398FC199D2")
        //check whether there is major already
        let userDefaults = UserDefaults.standard
        if (userDefaults.object(forKey: "Major") == nil)
        {
            
            
            
            userDefaults.set(23,forKey:"Major")
            
            userDefaults.synchronize()
            print("OK")
        }
        else
        {
            var a = userDefaults.integer(forKey: "Major")
            print(String(a))
        }
        
        let major : CLBeaconMajorValue = CLBeaconMajorValue(majorValue)
        let minor : CLBeaconMinorValue = 1
        let beaconID = "com.example.myDeviceRegion"
        
        return CLBeaconRegion(proximityUUID: proximityUUID!,
                              major: major, minor: minor, identifier: beaconID)
    }
    func advertiseDevice(region : CLBeaconRegion) {
        
        let peripheralData = region.peripheralData(withMeasuredPower: nil)
        
        peripheralManager.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
    }
    
    
    
    func peripheralManagerDidStartAdvertising(_ peripheral:CBPeripheralManager,error:NSError?){
        if let error = error{
            print("error:\(error)")
            return
        }
        print("succceed")
    }


}
