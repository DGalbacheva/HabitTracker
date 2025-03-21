//
//  SceneDelegate.swift
//  HabitTracker
//
//  Created by Doroteya Galbacheva on 14.03.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        
        let trackersViewController = HabitTrackerViewController()
        trackersViewController.tabBarItem.image = UIImage(named: "TabBarTrackerIcon")
        trackersViewController.tabBarItem.title = "Трекеры"
        
        let statsViewController = StatisticsViewController()
        statsViewController.tabBarItem.image = UIImage(named: "TabBarStatsIcon")
        statsViewController.tabBarItem.title = "Статистика"
        
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [trackersNavigationController, statsViewController]
        
        window.rootViewController = tabBarController
        
        self.window = window
        window.makeKeyAndVisible()
        
        tabBarController.tabBar.layer.borderWidth = 0.5
        tabBarController.tabBar.layer.borderColor = UIColor.ypGray.cgColor
        
    }
}

