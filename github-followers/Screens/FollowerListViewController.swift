//
//  FollowerListViewController.swift
//  github-followers
//
//  Created by Theodor Valiavko on 04/01/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import UIKit

protocol FollowerListViewControllerDelegate: class {
    func didRequestFollowers(for user: User)
}

final class FollowerListViewController: GFDataLoadingViewController {
    enum Section {
        case main
    }
    
    private let dataService: ManagedDataServicing

    private var followers: [Follower] = []
    private var filteredFollowers: [Follower] = []
    private var page = 1
    private var hasMoreFollowers = true
    private var isSearching = false
    private var username: String
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(username: String, dataService: ManagedDataServicing) {
        self.username = username
        self.dataService = dataService

        super.init(nibName: nil, bundle: nil)

        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        configureViewController()
        configureCollectionView()
        configureDataSource()
        configureSearchController()
        
        getFollowers(username: username, page: page)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func getFollowers(username: String, page: Int) {
        showLoadingView()
        
        dataService.getFollowers(for: username, page: page) { [weak self] result in
           guard let self = self else {
                return
            }
            
            self.dismissLoadingView()

            switch (result) {
            case .success(let followers):
                self.hasMoreFollowers = followers.count >= Config.numberOfItemsPerPage
                self.followers.append(contentsOf: followers)
                
                if self.followers.isEmpty {
                    let message = "This user doesn't have any followers. Go follow them 😊."

                    DispatchQueue.main.async {
                        self.showEmptyStateView(message: message, in: self.view)
                    }
                    
                    return
                }

                self.updateData(on: self.followers)

            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.makeThreeColumnFlowLayout(in: view))
        collectionView.delegate = self
        collectionView.prefetchDataSource = self

        view.addSubview(collectionView)

        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: CellIds.follower)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.follower, for: indexPath) as! FollowerCell
            if cell.avatarUpdateDelegate == nil {
                cell.avatarUpdateDelegate = ServiceUserCellUpdateDelegate(dataService: self.dataService)
            }
            
            cell.setFollower(follower)
            
            return cell
        })
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a person"
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
    
    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)

        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc private func addButtonTapped() {
        showLoadingView()
        
        dataService.getUser(for: username) { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                self.dataService.addToFavorites(follower: Follower(login: user.login, avatarUrl: user.avatarUrl))
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension FollowerListViewController: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if hasMoreFollowers && offsetY > contentHeight - height {
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let destinationViewController = UserInfoViewController(
            user: activeArray[indexPath.item],
            dataService: dataService)

        destinationViewController.delegate = self

        let navigationController = UINavigationController(rootViewController: destinationViewController)
        present(navigationController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension FollowerListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            return
        }
        
        isSearching = true
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        
        updateData(on: filteredFollowers)
    }
}

// MARK: - UISearchBarDelegate
extension FollowerListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false

        updateData(on: followers)
    }
}

// MARK: - UICollectionViewDataSourcePrefetching
extension FollowerListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // TODO FV: implement
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // TODO FV: implement
    }
}

// MARK: - FollowerListViewControllerDelegate
extension FollowerListViewController: FollowerListViewControllerDelegate {
    func didRequestFollowers(for user: User) {
        username = user.login
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        
        getFollowers(username: username, page: page)
    }
}
