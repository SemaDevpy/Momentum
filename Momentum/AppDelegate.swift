//
//  AppDelegate.swift
//  Momentum
//
//  Created by Syimyk on 3/30/21.
//

import UIKit
import Firebase
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        _ = Firestore.firestore()
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        return true
    }
}
