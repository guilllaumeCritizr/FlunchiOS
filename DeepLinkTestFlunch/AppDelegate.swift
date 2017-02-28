//
//  AppDelegate.swift
//  DeepLinkTestFlunch
//
//  Created by Guillaume Boufflers on 22/02/2017.
//  Copyright © 2017 Guillaume Boufflers. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.applicationIconBadgeNumber = 0
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
        // Will pass through this condition if the app is opened up using a push notification while the app is closed (killed)
        if let remoteNotificationInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [NSObject : AnyObject]{
            self.application(application, didReceiveRemoteNotification: remoteNotificationInfo)
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    // Launched by tapping open on a notification while th app is in the background or the foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        print("Push notification received: \(data)")
        if (data["czlink"] != nil){
            print(data["czlink"] ?? "Could not make it work ..")
            let url = URL(string: data["czlink"] as! String)
            if (url != nil){
                performUrlCall(url: url!)
            }
        } else {
            print("This was not a notification from with Critizr Payload")
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // Launched with a Universal Link
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        let url = userActivity.webpageURL
        performUrlCall(url: url!)
        return true
    }
    
    // Launched with a URIScheme
    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        print(url)
        let stringUrl = url.absoluteString
        print("URL => " + stringUrl)
        if (stringUrl.range(of:"customer") != nil && stringUrl.range(of:"shortner") != nil) {
            print("This is a Customer+Shortner call")
            openWithShortner(open: url)
        } else if (stringUrl.range(of:"cz_store") != nil) {
            openWtithStoreId(open: url)
        }
        return true
    }
    
    func performUrlCall(url: URL){
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if(error != nil) {
                print("Error with data")
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    let storeId = json["storeId"] as? String
                    let urlParams = json["params"] as AnyObject
                    
                    print(json)
                    print(storeId ?? "Error printing storeId")
                    print(urlParams)
                    
                    DispatchQueue.main.async {
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LaDeuxieme") as! FeedbackViewController
                        initialViewController.storeId = storeId!
                        initialViewController.params = urlParams
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                    }
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
    }
    
    func openWithShortner(open url: URL){
        let host = url.host
        print(host ?? "Error printing host")
        let params = host?.components(separatedBy: "&")
        var customer = ""
        var shortner = ""
        for p in params! {
            if (p.hasPrefix("cz_customer=")){
                customer = p.components(separatedBy: "=")[1]
            } else if (p.hasPrefix("cz_shortner=")){
                shortner = p.components(separatedBy: "=")[1]
            }
        }
        let newUrl = "https://critizr.herokuapp.com/" + customer + "/" + shortner
        print(newUrl)
        
        let finalUrl = URL(string: newUrl)
        performUrlCall(url: finalUrl!)
    }
    
    func openWtithStoreId(open url: URL){
        let host = url.host
        print(host ?? "Error printing host")
        let params = host?.components(separatedBy: "&")
        var storeId = ""
        var namesDictionary: Dictionary<String, String> = [:]
        for p in params! {
            print(p)
            if (p.hasPrefix("cz_store=")){
                storeId = p.components(separatedBy: "=")[1]
            } else {
                namesDictionary[p.components(separatedBy: "=")[0].replacingOccurrences(of: "cz_", with: "")] = p.components(separatedBy: "=")[1]
            }
        }
        print(namesDictionary)
        DispatchQueue.main.async {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LaDeuxieme") as! FeedbackViewController
            initialViewController.storeId = storeId
            initialViewController.params = namesDictionary as AnyObject?
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    
    func applicationDidEnterBackground(_ application: UIApplication) {}
    
    func applicationWillEnterForeground(_ application: UIApplication) { UIApplication.shared.applicationIconBadgeNumber = 0 }
    
    func applicationDidBecomeActive(_ application: UIApplication) {}
    
    func applicationWillTerminate(_ application: UIApplication) {}
}
