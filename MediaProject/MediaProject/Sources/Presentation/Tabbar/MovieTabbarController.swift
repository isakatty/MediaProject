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
            ViewController(),
            SearchViewController(),
            TrendMovieViewController()
        ]
        
        setViewControllers(
            configureTabs(vcGroup: vcs),
            animated: true
        )
    }
    private func configureTabs(vcGroup: [UIViewController]) -> [UINavigationController] {
        var tabGroup = [UINavigationController]()
        
        for (index, vc) in vcGroup.enumerated() {
            for item in TabbarCase.allCases {
                if index == item.rawValue {
                    let tabbar = UITabBarItem(
                        title: item.tabBarName,
                        image: UIImage(systemName: item.nomalIconName),
                        selectedImage: UIImage(systemName: item.tintedIconName)
                    )
                    let navi = UINavigationController(rootViewController: vc)
                    navi.tabBarItem = tabbar
                    tabGroup.insert(navi, at: index)
                }
            }
        }
        
        return tabGroup
    }
}
