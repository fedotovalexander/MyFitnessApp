//
//  MainTabBarController.swift
//  FirstApp
//
//  Created by Alexander Fedotov on 21.01.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupItems()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .specialTabBar
        tabBar.tintColor = .specialDarkGreen
        tabBar.unselectedItemTintColor = .specialGray
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.specialLightBrown.cgColor
        
    }
    
    private func setupItems() {
        let mainVC = MainViewController()
        let statisticVC = StatisticWorkoutViewController()
        let profileVC = ProfileViewController()
        
        setViewControllers([mainVC, statisticVC, profileVC], animated: true)
        
        guard let items = tabBar.items else { return }
        
        items[0].title = "Main"
        items[1].title = "Statistic"
        items[2].title = "Profile"
        
        items[0].image = UIImage(named: "tabBarMain")
        items[1].image = UIImage(named: "tabBarStatistic")
        items[2].image = UIImage(named: "tabBarProfile")
    }
}


