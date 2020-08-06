//
//  UserInfoViewController.swift
//  github-followers
//
//  Created by Theodor Valiavko on 14/01/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import UIKit

protocol UserInfoViewControllerDelegate: class {
    func didRequestProfile(for user: User)
    func didRequestFollowers(for user: User)
}

final class UserInfoViewController: GFDataLoadingViewController {
    private let dataService: ManagedDataServicing
    
    private let headerView = UIView()
    private let itemViewOne = UIView()
    private let itemViewTwo = UIView()
    private let dateLabel = GFBodyLabel(textAlignment: .center)

    private var user: Follower

    weak var delegate: FollowerListViewControllerDelegate?
    
    init(user: Follower, dataService: ManagedDataServicing) {
        self.user = user
        self.dataService = dataService
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        layoutUI()

        getUserData()
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.leftBarButtonItem = doneBtn
    }
    
    private func configureUIElements(with user: User) {
        let repoItemVC = GFRepoItemViewController(user: user)
        repoItemVC.delegate = self

        let followerItemVC = GFFollowerItemInfoViewController(user: user)
        followerItemVC.delegate = self
        
        self.add(childViewController: GFUserInfoHeaderViewController(user: user, dataService: dataService), to: self.headerView)
        self.add(childViewController: repoItemVC, to: self.itemViewOne)
        self.add(childViewController: followerItemVC, to: self.itemViewTwo)

        self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())."
    }
    
    private func layoutUI() {
        let padding: CGFloat = 20
        
        let itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        for itemView in itemViews {
            itemView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(itemView)
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            ])
        }
        
        let itemHeight: CGFloat = 140

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func add(childViewController: UIViewController, to containerView: UIView) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }
    
    private func getUserData() {
        showLoadingView()
        
        dataService.getUser(for: user.login) { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.dismissLoadingView()
            
            switch(result) {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElements(with: user)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

// MARK: - UserInfoViewControllerDelegate
extension UserInfoViewController: UserInfoViewControllerDelegate {
    func didRequestProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The URL attached to this user is invalid.", buttonTitle: "Ok")
            return
        }
        
        presentSafariViewController(with: url)
    }
    
    func didRequestFollowers(for user: User) {
        guard user.followers > 0 else {
            presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers.", buttonTitle: "Ok")
            return
        }
        
        if let delegate = delegate {
            delegate.didRequestFollowers(for: user)
            dismissViewController()
        }
    }
}
