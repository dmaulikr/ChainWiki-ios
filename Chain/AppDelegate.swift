//
//  AppDelegate.swift
//  Chain
//
//  Created by Jitae Kim on 8/25/16.
//  Copyright © 2016 Jitae Kim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import FBSDKLoginKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        Database.database().isPersistenceEnabled = true
        Database.database().reference().keepSynced(true)
        
        // Login Providers
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        // check for update
        if defaults.getStoredVersion() == nil || defaults.getStoredVersion() != defaults.getCurrentVersion() {
            defaults.setImagePermissions(value: true)
            defaults.updateVersion()
        }

//        AppRater.appRater.incrementAppLaunches()
        
        var initialViewController = UIViewController()
        
        if defaults.isLoggedIn() {
            initialViewController = MyTabBarController()
        }
            
        else {
            initialViewController = PageViewController()
        }
        
        // log user's view preferences for all views.
        if !defaults.hasLoggedViewPref() {
            defaults.setLoggedViewPref()
            
            if let searchView = defaults.getSearchView() {
                Analytics.logEvent("ArcanaViewPref", parameters: [
                    "viewPref": searchView as NSObject,
                    ])
            }
            
        }
        
        window!.rootViewController = initialViewController
        window!.makeKeyAndVisible()

        return true
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.scheme == "ccwiki" {
            // push the arcana vc
            if let query = url.query {
                var arcanaID = query.replacingOccurrences(of: "arcana=", with: "")
                arcanaID = arcanaID.replacingOccurrences(of: ")", with: "")
                let vc = LoadingArcanaViewController(arcanaID: arcanaID)
                window?.rootViewController?.present(vc, animated: true, completion: nil)
            }
            
            
            return true
        }
        else {
            
            let facebookHandler = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
            
            let googleHandler = GIDSignIn.sharedInstance().handle(url,
                                                                  sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                                  annotation: [:])
            
            return facebookHandler || googleHandler
        }
        
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let _ = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return false
        }
        
        guard let webpageUrl = URL(string: "ccwiki://\(url)") else { return false }
        application.openURL(webpageUrl)
        
        return false
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        handleUserInfo(userInfo)
    }
    
    func handleUserInfo(_ userInfo: [AnyHashable: Any]) {
        if let type = userInfo["type"] as? String {
            if type == "festival" {
                showFestivalVC()
            }
        }
    }
    
    func showFestivalVC() {
        guard let tabVC = self.window?.rootViewController as? MyTabBarController else { return }
        tabVC.selectedIndex = 0
        
        guard let splitVC = tabVC.viewControllers?.first as? ArcanaSplitViewController,
            let navVC = splitVC.viewControllers.first as? NavigationController else { return }
        navVC.popToRootViewController(animated: false)
        
        let festivalVC = FestivalViewController()
        navVC.pushViewController(festivalVC, animated: true)
    }
}
