//
//  AppDelegate.swift
//  DailyRythmn
//
//  Created by Niklas Großmann on 07.11.18.
//  Copyright © 2018 Mobile_App_Uni_Ulm. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    // func that shows alert even when the app is open
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

    //func that manages what will happen when user clicks on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
//        if response.notification.request.identifier == "testIdentifier" {
            //TODO: das richtige event öffnen
            print("Notification with Identifier: \(response.notification.request.identifier) is clicked")
        
        completionHandler()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            print("Granted user permission? \(granted)")
            
        }
        
        /* Timeinterval in which the background check is done */
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(30)
        return true
    }

    
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void) {
        // Check for new data.
//        if let newData = fetchUpdates() {
//            addDataToFeed(newData: newData)
//
//            if (!(JSONDataManager.loadAll(Event.self).isEmpty)) {
//
//            }
//            completionHandler(.newData)
//        }
//        completionHandler(.noData)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
//        print("Enter background")
//        EventManager.getInstance().updateJSONEvents()
//        var allEventArray = JSONDataManager.loadAll(Event.self)
//        var allRestTimes: [Int]
//        var index = 0
//        for tempEvent in allEventArray {
//            EventManager.getInstance().getTimeTillNextCheckAction(from: tempEvent, completion: { (tempResult: Int) in
//                allRestTimes[index] = tempResult
//            })
//            index = index + 1
//        }
//        DispatchQueue.main.async {
//            allRestTimes.sort()
//
//        }
        
//        UIApplication.shared.setMinimumBackgroundFetchInterval(3600)
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        EventManager.getInstance().updateJSONEvents()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

