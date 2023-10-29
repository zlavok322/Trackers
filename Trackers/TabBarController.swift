import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let trackersViewController = UINavigationController(rootViewController: TrackersViewController())
        trackersViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Трекеры", comment: ""),
            image: UIImage(named: "trackersIcon"),
            selectedImage: nil)
        
        let statisticViewController = UINavigationController(rootViewController: StatisticViewController())
        statisticViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Статистика", comment: ""),
            image: UIImage(named: "statisticIcon"),
            selectedImage: nil)
        
        self.viewControllers = [trackersViewController, statisticViewController]
    }

}
