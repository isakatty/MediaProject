//
//  MovieTabbarController.swift
//  MediaProject
//
//  Created by Jisoo Ham on 6/28/24.
//

import UIKit

final class MovieTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabbar()
    }
    
    private func configureTabbar() {
        tabBar.backgroundColor = .clear
        tabBar.tintColor = .black
        
        let vcs = [
            NewTrendViewController(viewTitle: ViewCase.trend.viewTitle),
            SearchViewController(viewTitle: ViewCase.search.viewTitle),
            MemoCalendarViewController(viewTitle: ViewCase.calendar.viewTitle)
        ]
        
        setViewControllers(
            configureTabs(vcGroup: vcs),
            animated: true
        )
    }
    private func configureTabs(vcGroup: [UIViewController]) -> [UINavigationController] {
        return vcGroup.enumerated().compactMap { (index, vc) in
            guard let tabBarItemCase = TabbarCase(rawValue: index) else { return nil }
            let tab = UITabBarItem(
                title: tabBarItemCase.tabBarName,
                image: UIImage(systemName: tabBarItemCase.nomalIconName),
                selectedImage: UIImage(systemName: tabBarItemCase.tintedIconName)
            )
            let navController = UINavigationController(rootViewController: vc)
            navController.tabBarItem = tab
            return navController
        }
    }
}
