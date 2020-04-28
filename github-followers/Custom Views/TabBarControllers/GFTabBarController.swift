//
//  GFTabBarController.swift
//  github-followers
//
//  Created by Theodor Valiavko on 23/04/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import UIKit

final class GFTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = .systemGreen
        
        viewControllers = [makeSearchNavigationController(), makeFavoritesNavigationController()]
    }
    
    private func makeSearchNavigationController() -> UINavigationController {
        let searchVC = SearchViewController()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    private func makeFavoritesNavigationController() -> UINavigationController {
        let favoritesVC = FavoritesViewController()
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoritesVC)
    }
}
