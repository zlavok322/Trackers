//
//  ViewController.swift
//  Trackers
//
//  Created by Слава Шестаков on 06.10.2023.
//

import UIKit

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        trackersViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Трекеры", comment: ""),
            image: UIImage(named: "trackers icon"),
            selectedImage: nil)
        
        let statisticViewController = UINavigationController(rootViewController: StatisticViewController())
        statisticViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Статистика", comment: ""),
            image: UIImage(named: "statistic icon"),
            selectedImage: nil)
        
        self.viewControllers = [trackersViewController, statisticViewController]
    }

}
