//
//  AppDelegate.swift
//  RITW.HelloWorld
//
//  Created by XIndong Zhang on 2017/1/28.
//  Copyright © 2017年 SmackInnovations. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // When you type customSchemeExample://red in the search bar in Safari
        let urlScheme = url.scheme //[URL_scheme]
        let host = url.host //red
        
        // When you type customSchemeExample://?backgroundColor=red or customSchemeExample://?backgroundColor=green
        
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if let haha = urlComponents?.queryItems{
            let items = (haha) as [NSURLQueryItem] // {name = backgroundcolor, value = red}
            
            if (url.scheme == "openapptest"){
                NSLog("Inn")
                var color: UIColor? = nil
                var vcTitle = ""
                if let _ = items.first, let propertyName = items.first?.name, let propertyValue = items.first?.value{
                    NSLog("Name " + propertyName)
                    NSLog("Value " + propertyValue)
                    
                    vcTitle = propertyName
                    if (propertyValue=="red"){
                        color = .red
                    }
                    else if (propertyValue=="green"){
                        color = .green
                    }
                    
                    if (color != nil) {
                        let vc = UIViewController()
                        vc.view.backgroundColor = color
                        vc.title = vcTitle
                        let navController = UINavigationController(rootViewController: vc)
                        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismiss))
                        vc.navigationItem.leftBarButtonItem = barButtonItem
                        self.window?.rootViewController?.present(navController, animated: true, completion: nil)
                        return true
                    }                
                }
            }
        }
        if let haha = host{
            NSLog("Host" + host!)
        }
        
        
        return false
    }
    
    func dismiss() {
        self.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    
    
    private func application(app: UIApplication, openURL url: URL, options: [String : AnyObject]) -> Bool {
        
        //这里进行判断是哪一个app在打开此app，然后分别进行操作
        let scheme = url.scheme
        //不分大小写比较
        if scheme?.caseInsensitiveCompare("OpenAppTest") == .orderedSame{
            
            //执行跳转，跳转到你想要的页面
            let alert = UIAlertView(title: "\(scheme)", message: "\(url)", delegate: self, cancelButtonTitle: "Yes")//iOS, introduced=2.0, deprecated=9.0
            alert.show()
            
            let vc = ViewController()
            if let navVC = self.window?.rootViewController as? UINavigationController{
                navVC.pushViewController(vc, animated: true)
            }
            
            
            return true
            
        }
        
        return true
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
