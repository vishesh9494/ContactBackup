//
//  AppDelegate.swift
//  ContactBackup
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.CreateDatabse()
        
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.white
        UIPageControl.appearance().backgroundColor = Util_Color.GetBlueolor()
        UIPageControl.appearance().layer.borderColor = UIColor.white.cgColor;
        
        var initialViewController : UIViewController!
        let objStoryboard = UIStoryboard(name:"Main",bundle:nil)
        
        
        if (UserDefaults.standard.object(forKey: "userid") != nil)
        {
            let isLogin : NSString = UserDefaults.standard.object(forKey: "userid") as! NSString
            
            
            if isLogin.length > 0
            {
                if isLogin.length == 1
                {
                    initialViewController  = objStoryboard.instantiateViewController(withIdentifier: "DownloadContactVC")
                   // initialViewController.setDownlodView(isFromView.Registration)
                    startBGService()
                }
                else
                {
                    initialViewController   = objStoryboard.instantiateViewController(withIdentifier: "TabBarController")
                    startBGService()
                }
            }
            else
            {
                initialViewController = objStoryboard.instantiateViewController(withIdentifier: "LaunchScreen")
            }
        }
        else
        {
            initialViewController = objStoryboard.instantiateViewController(withIdentifier: "LaunchScreen")
        }
        
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func CreateDatabse()->Void
    {
        let db = DatabaseManager()
          if db.CreateDatabse()
          {
            print("Database Create")
          }
        else
          {
            print("Error in create database")
          }
    }
    func startBGService()->Void
    {
        if (UserDefaults.standard.object(forKey: "userid") != nil)
        {
            let isLogin : NSString = UserDefaults.standard.object(forKey: "userid") as! NSString
            
            
            if isLogin.length > 0
            {
                let uplodBG = UploadContactBG()
                uplodBG.GetUploadContactList()
                
                let downBG = DownloadContactBG()
                downBG.DownloadContacts()
            }
            
        }
        
    }
}

