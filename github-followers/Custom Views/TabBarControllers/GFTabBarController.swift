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

        let dataService = makeDataService()
        viewControllers = [
            makeSearchNavigationController(dataService: dataService),
            makeFavoritesNavigationController(dataService: dataService)
        ]
    }
    
    private func makeSearchNavigationController(dataService: ManagedDataServicing) -> UINavigationController {
        let searchVC = SearchViewController(dataService: dataService)
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    private func makeFavoritesNavigationController(dataService: ManagedDataServicing) -> UINavigationController {
        let favoritesVC = FavoritesViewController(dataService: dataService)
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favoritesVC)
    }
    
    private func makeDataService() -> ManagedDataServicing {
        let apiClient = GitHubAPIClient(networkService: NetworkService())
        let factory = SimpleServiceFactory()
        let dataService = factory.makeManagedDataService(usersService: factory.makeUsersService(apiClient: apiClient),
                                                         followersService: factory.makeFollowersService(apiClient: apiClient),
                                                         avatarService: factory.makeAvatarsService(apiClient: apiClient),
                                                         cacheService: factory.makeCacheService())

        return dataService
    }
}
