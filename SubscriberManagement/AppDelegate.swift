//
//  AppDelegate.swift
//  SubscriberManagement
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure navigation bar
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .greenMailerLite

        // Firebase config
        FirebaseApp.configure()

        // Present Navigation
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(
            rootViewController: SubscriberListViewController()
        )

        return true
    }


}

