//
//  AppDelegate.swift
//  try2
//
//  Created by Wyat Da on 16/06/2017.
//  Copyright © 2017 Vtec. All rights reserved.
//

// According to Apple's documentation https://developer.apple.com/library/content/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothBackgroundProcessingForIOSApps/PerformingTasksWhileYourAppIsInTheBackground.html
//when an ios device is acting as a pheripheral in background, it can only be scanned by another ios device, which has been proved by experiment on Locate App. Since the gateway is raspberry pi, the background broadcasting is not avilable. So the bgm solution is appoved.




import UIKit
import CoreBluetooth
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CBPeripheralManagerDelegate {
    
    var window: UIWindow?
    
    
    
    var peripheralManager : CBPeripheralManager!
    
    
    
    
    
        
        
      
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //AudioManager.shared.openBackgroundAudioAutoPlay = true
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("enter")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
       
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func peripheralManagerDidUpdateState(_ peripheral:CBPeripheralManager){
        print("state:\(peripheral.state)")
        //let advertisementData = [CBAdvertisementDataLocalNameKey: "TestDevice"]
        //peripheralManager.startAdvertising(advertisementData)
        
//        let a = CBPeripheralManager.authorizationStatus()
//        switch a {
//            
//        case .authorized:
//            print("ok")
//            advertiseDevice(region : createBeaconRegion(CLBeaconMajorValue(1000)))
//        default:
//            print("no")
//        }

        advertiseDevice(region : createBeaconRegion(CLBeaconMajorValue(1000)))
        
        
    }
    
    
    func advertiseDevice(region : CLBeaconRegion) {
        
        let peripheralData = region.peripheralData(withMeasuredPower: nil)
        
        peripheralManager.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
        //        print(peripheralData.address)
        //        print(peripheral.)
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
    
    
//    var peripheralManager: CBPeripheralManager!
//    var userDefaults = UserDefaults.standard
//    
//    //var majorValue_string = "initializing"
//        
//        
//      
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        AudioManager.shared.openBackgroundAudioAutoPlay = true
//        return true
//    }
//    
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    }
//    
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        peripheralManager = CBPeripheralManager(delegate:self,queue:nil)
//        
//    }
//    
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        
//        
//    }
//    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }
//    
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }
//
//    
//    
//    
//    func peripheralManagerDidUpdateState(_ peripheral:CBPeripheralManager){
//        print("state:\(peripheral.state.rawValue)")
//        //let advertisementData = [CBAdvertisementDataLocalNameKey: "TestDevice"]
//        //peripheralManager.startAdvertising(advertisementData)
//       
//            advertiseDevice(region : createBeaconRegion())
//        
//        
//    }
//    
//    
//    
//    func createBeaconRegion() -> CLBeaconRegion{
//        let proximityUUID = UUID(uuidString:
//            "39ED98FF-2900-441A-802F-9C398FC199D2")
//        //check whether there is major already
//        //let userDefaults = UserDefaults.standard
//        
//        //let major : CLBeaconMajorValue = majorValue
//        //print(major)
//        let major : CLBeaconMajorValue = 100
//        
//        let minor : CLBeaconMinorValue = 1
//        let beaconID = "com.example.myDeviceRegion"
//        
//        return CLBeaconRegion(proximityUUID: proximityUUID!,
//                              major: major, minor: minor, identifier: beaconID)
//    }
//    
//    
//    
//    
//    
//    func advertiseDevice(region : CLBeaconRegion) {
//        
//        let peripheralData = region.peripheralData(withMeasuredPower: nil)
//        
//        peripheralManager.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
//        print(peripheral.adrdress)
//    }
//    
//    
//    
//    
//    
//    
//    func peripheralManagerDidStartAdvertising(_ peripheral:CBPeripheralManager,error:NSError?){
//        if let error = error{
//            print("error:\(error)")
//            return
//        }
//        print("succceed")
//    }
    
    
   
    
}


   


