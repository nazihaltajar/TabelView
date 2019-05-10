//
//  AppDelegate.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 15/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications

enum QuickAction: String {
    case OpenFavourites = "OpenFavorites"
    case OpenDiscover = "OpenDiscover"
    case NewRestaurant = "NewRestaurant"

    init?(fullIdentifier: String) {
        guard let shortcutIdentifier = fullIdentifier.components(separatedBy: ".").last
            else {
                return nil
        }
        self.init(rawValue: shortcutIdentifier)
    }
}
var database: DatabaseProtocol = FirebaseDatabase()
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let backButtonImage = UIImage(named: "back")
        UINavigationBar.appearance().backIndicatorImage = backButtonImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backButtonImage
        //RestaurantGroup.populateDb()
        UITabBar.appearance().tintColor = .tabBarTintColor
        UITabBar.appearance().barTintColor = .black
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {(granted, _) in
            if granted {
                print("User notifications are allowed.")
            } else {
                print("User notifications are not allowed")
            }
        }
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleQuickAction(shortcutItem: shortcutItem))
    }

    private func handleQuickAction (shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = QuickAction(fullIdentifier: shortcutType) ,
            let tabBarController = window?.rootViewController as? UITabBarController
            else { return false }

        switch shortcutIdentifier {
        case .OpenFavourites:
            tabBarController.selectedIndex = 0
        case .OpenDiscover:
            tabBarController.selectedIndex = 1
        case .NewRestaurant:
            if let restaurantTableViewController = tabBarController.viewControllers?[0].children[0] {
                restaurantTableViewController.performSegue(withIdentifier: "addRestaurant", sender: restaurantTableViewController)
            } else {
                return false
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "foodpin.makeReservation",
            let phone = response.notification.request.content.userInfo["phone"],
            let url = URL(string: "tel://\(phone)"),
            UIApplication.shared.canOpenURL(url) {
                print("Make reservation")
                UIApplication.shared.open(url)
        }
        completionHandler()
    }
}
