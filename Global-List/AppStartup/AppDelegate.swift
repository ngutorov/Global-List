//
//  AppDelegate.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/10/21.
//

import UIKit
import Swinject
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    
    // Container DI
    static let container = Container()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Enable Keyboard Manager
        IQKeyboardManager.shared.enable = true
        
        // Register Dependencies
        AppDelegate.container.registerDependencies()
        
        if #available(iOS 13, *) {
            // *** Only iOS 13 ***
        } else {
            
            // MARK: - iOS 12 support
            
            // *** Only iOS 12 ***
            window = UIWindow(frame: UIScreen.main.bounds)
            
            // Start Application
            appCoordinator = AppDelegate.container.resolve(AppCoordinator.self)!
            appCoordinator.start()
            window?.rootViewController = appCoordinator.rootViewController
            window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

