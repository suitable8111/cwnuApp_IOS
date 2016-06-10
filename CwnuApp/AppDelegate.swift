//
//  AppDelegate.swift
//  CwnuApp
//
//  Created by 김대호 on 2016. 3. 4..
//  Copyright © 2016년 KimDaeho. All rights reserved.
//

import UIKit
//import Google



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var loginViewController: UIViewController?
    var mainViewController: UIViewController?
    
    var deviceToken: NSData? = nil
    
    private func setupEntryController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewControllerWithIdentifier("navigator") as! UINavigationController
        let navigationController2 = storyboard.instantiateViewControllerWithIdentifier("navigator") as! UINavigationController
        
        let viewController = storyboard.instantiateViewControllerWithIdentifier("login") as UIViewController
        navigationController.navigationBar.barStyle = .Default
        navigationController.pushViewController(viewController, animated: true)
        self.loginViewController = navigationController
        
        let viewController2 = storyboard.instantiateViewControllerWithIdentifier("cert") as UIViewController
        
        navigationController2.navigationBar.barStyle = .Default
        navigationController2.pushViewController(viewController2, animated: true)
        
        self.mainViewController = navigationController2
        
    }
    
    private func reloadRootViewController() {
        let isOpened = KOSession.sharedSession().isOpen()
        if !isOpened {
            let mainViewController = self.mainViewController as! UINavigationController
            
            let stack = mainViewController.viewControllers
            for i in 0 ..< stack.count {
                print(NSString(format: "[%d]: %@", i, stack[i] as UIViewController))
            }
            mainViewController.popToRootViewControllerAnimated(true)
        }
        
        self.window?.rootViewController = isOpened ? self.mainViewController : self.loginViewController
        self.window?.makeKeyAndVisible()
    }
    
    private func setTableViewSelectedBackgroundViewColor() {
        let colorView = UIView()
        colorView.backgroundColor = UIColor(red: 0xff / 255.0, green:  0xcc / 255.0, blue:  0x00 / 255.0, alpha: 1.0)
        UITableViewCell.appearance().selectedBackgroundView = colorView
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        // 최초 실행시 2 종류의 rootViewController 를 준비한다.
        setupEntryController()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.kakaoSessionDidChangeWithNotification), name: KOSessionDidChangeNotification, object: nil)
        
        reloadRootViewController()
        setTableViewSelectedBackgroundViewColor()
        
        // notification
        if #available(iOS 8.0, *) {
            let types: UIUserNotificationType = [UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound]
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            application.registerForRemoteNotificationTypes([UIRemoteNotificationType.Badge, UIRemoteNotificationType.Sound, UIRemoteNotificationType.Alert])
        }
        
        let session = KOSession.sharedSession()
        session.presentedViewBarTintColor = UIColor(red: 0x2a / 255.0, green: 0x2a / 255.0, blue: 0x2a / 255.0, alpha: 1.0)
        session.presentedViewBarButtonTintColor = UIColor(red: 0xe5 / 255.0, green: 0xe5 / 255.0, blue: 0xe5 / 255.0, alpha: 1.0)
        
//        let gai = GAI.sharedInstance()
//        let id = "my-GA-id"
//        gai.trackerWithTrackingId(id)
//        gai.trackUncaughtExceptions = true
//        gai.logger.logLevel = GAILogLevel.Verbose
        
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
//
//        
        initPlist()
        return true
    }
    func initPlist(){
        let fileManager = NSFileManager()
        //var error = NSError()
        var path = NSString()
        path = getPlistPath()
        
        print(path)
        let success = fileManager.fileExistsAtPath(path as String)
        
        if(!success){
            let defalutPath = NSBundle.mainBundle().resourcePath?.stringByAppendingString("/bestFoodPList.plist")
            
            do {
                try fileManager.copyItemAtPath(defalutPath!, toPath: path as String)
            } catch _ {
            }
        }
        
    }
    
    func getPlistPath() -> String {
        var docsDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docPath = docsDir[0]
        let fullName = docPath.stringByAppendingString("/bestFoodPList.plist")
        return fullName
    }
    
    
    func kakaoSessionDidChangeWithNotification() {
        reloadRootViewController()
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return KOSession.handleOpenURL(url)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return KOSession.handleOpenURL(url)
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

