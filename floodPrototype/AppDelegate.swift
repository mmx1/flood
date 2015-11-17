//
//  AppDelegate.swift
//  floodPrototype
//
//  Created by Mark Xue on 11/10/15.
//  Copyright © 2015 Mark Xue. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func setHardCodeData(){
        
        let currentVersion = NSUserDefaults.standardUserDefaults().floatForKey("dataVersion");
        if let path = NSBundle.mainBundle().pathForResource("assets/foodData", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
                
                
                if let jsonDictionary = jsonResult as? [String:AnyObject],
                    let newVersion = jsonDictionary["version"] as? Float where currentVersion < newVersion,
                    let foodItems = jsonDictionary["foods"] as? [[String:AnyObject]]{
                    
                        NSUserDefaults.standardUserDefaults().setObject(foodItems, forKey: "foodDictionary")
                        
                        NSUserDefaults.standardUserDefaults().setFloat(jsonResult["version"] as! Float, forKey: "dataVersion")
                    
                    
                }
                
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setHardCodeData();
        
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

