//
//  SceneDelegate.swift
//  PushDemo
//
//  Created by GZOffice_hao on 2019/12/2.
//  Copyright © 2019 vito. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        notificationCenter.getNotificationSettings { [weak self] settings in
            guard let strongSelf = self else { return }
            if settings.authorizationStatus == .notDetermined {
                // 未选择
                // request authorization
                notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] (granted, error) in
                    guard let strongSelf = self else { return }
                    // request authorization call back
                    if granted {
                        strongSelf.registerForRemoteNotifications()
                    } else {
                        if let error = error {
                            print("request authorization error > \(error.localizedDescription)")
                        }
                    }
                }
            } else if settings.authorizationStatus == .denied {
                // 已拒绝
                
            } else if settings.authorizationStatus == .authorized {
                // 已授权
                strongSelf.registerForRemoteNotifications()
                
                let seeMore = UNNotificationAction(identifier: "seeMore", title: "See More", options: .foreground)
                let close = UNNotificationAction(identifier: "close", title: "Close", options: .destructive)
                let category = UNNotificationCategory(identifier: "categoryidentifier", actions: [close, seeMore], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: nil, categorySummaryFormat: nil, options: .customDismissAction)
                notificationCenter.setNotificationCategories([category])
            }
        }
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    private func registerForRemoteNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}

extension SceneDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Push title", message: response.notification.request.content.body, preferredStyle: .alert)
        alert.addAction(.init(title: "Close", style: .cancel, handler: nil))
        window?.rootViewController?.show(alert, sender: nil)
        // 当 app 在后台时，点击 push 时的回调
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 当 app 在前台时收到push的回调, 调用 completionHandler 告知系统用什么方式显示
        completionHandler(.alert)
    }
}

