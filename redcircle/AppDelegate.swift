//
//  AppDelegate.swift
//  redcircle
//
//  Created by zhan on 16/10/31.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RCIMReceiveMessageDelegate, UNUserNotificationCenterDelegate {



    var window: UIWindow?
    
//    static let baseURLString = "http://192.168.1.102:8080"

    static let baseURLString = "http://snowjlz.gicp.net:19959/redcircle"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window?.backgroundColor = UIColor.lightGray
        let userInfo = UserDefaults.standard.value(forKey: "USER_INFO") as? NSDictionary
        if userInfo == nil {
            let loginController = LoginController()
            let loginNavController = UINavigationController(rootViewController: loginController)
            self.window?.rootViewController = loginNavController
            //            self.presentViewController(loginController, animated: true, completion: { () -> Void in
            //
            //            })
        } else {
            let homeController = HomeController()
            self.window?.rootViewController = homeController
        }

        SMSSDK.registerApp("111412781a7c4", withSecret: "81008993f3de84d463ccd91cf4bb7509")
        RCIM.shared().initWithAppKey("sfci50a7c2fsi")

        //推送处理1
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                
                // Enable or disable features based on authorization.
                if granted == true
                {
                    print("Allow")
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else
                {
                    print("Don't Allow")
                }
            }
        } else {
            //注册推送,用于iOS8以下系统
            application.registerForRemoteNotifications(matching: [.badge, .alert, .sound])
        }
        
        //设置消息接收的监听
        RCIM.shared().receiveMessageDelegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.didReceiveMessageNotification(notification:)), name: NSNotification.Name.RCKitDispatchMessage, object: nil)
        
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        RCIMClient.shared().setDeviceToken(deviceTokenString)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        
    }
    
    
    /*!
     接收消息的回调方法
     
     @param message     当前接收到的消息
     @param left        还剩余的未接收的消息数，left>=0
     
     @discussion 如果您设置了IMKit消息监听之后，SDK在接收到消息时候会执行此方法（无论App处于前台或者后台）。
     其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
     您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
     */
    public func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        if (left != 0) {
            print("收到一条消息，当前的接收队列中还剩余\(left)条消息未接收，您可以等待left为0时再刷新UI以提高性能")
        } else {
            print("收到一条消息")
        }
    }
    
    func didReceiveMessageNotification(notification: NSNotification) {
        let message = notification.object as! RCMessage
        if (message.messageDirection == .MessageDirection_RECEIVE) {
            UIApplication.shared.applicationIconBadgeNumber = Int(RCIMClient.shared().getTotalUnreadCount())
        }
    }
    

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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


}



extension Data {
    func hexString() -> String {
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}
