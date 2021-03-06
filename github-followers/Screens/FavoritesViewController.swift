//
//  FavoritesViewController.swift
//  github-followers
//
//  Created by Theodor Valiavko on 04/01/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import UIKit

final class FavoritesViewController: GFDataLoadingViewController {
    private let dataService: ManagedDataServicing
    
    private let tableView = UITableView()
    private var favorites: [Follower] = []
    
    init(dataService: ManagedDataServicing) {
        self.dataService = dataService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getFavorites()
    }
    
    private func getFavorites() {
        let favorites = dataService.favorites
        if favorites.isEmpty {
            showEmptyStateView(message: "No favorites?\nAdd on the follower screen.", in: view)
        } else {
            self.favorites = favorites

            tableView.reloadData()

            DispatchQueue.main.async {
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: CellIds.favorite)
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let followerListVC = FollowerListViewController(
            username: favorites[indexPath.row].login,
            dataService: dataService)

        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .top)
        
        dataService.removeFromFavorites(follower: favorite)
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIds.favorite) as! FavoriteCell
        if cell.avatarUpdateDelegate == nil {
            cell.avatarUpdateDelegate = ServiceUserCellUpdateDelegate(dataService: dataService)
        }
        
        cell.setFavorite(favorites[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension FavoritesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            NetworkManager.shared.prefetchImage(from: favorites[indexPath.row].avatarUrl)
//        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            NetworkManager.shared.cancelTask(for: favorites[indexPath.row].avatarUrl)
//        }
    }
}
