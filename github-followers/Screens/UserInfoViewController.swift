//
//  UserInfoViewController.swift
//  github-followers
//
//  Created by Theodor Valiavko on 14/01/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()

    var username: String!
    
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
        navigationItem.rightBarButtonItem = doneBtn
    }
    
    private func layoutUI() {
        itemViewOne.backgroundColor = .systemPink
        itemViewTwo.backgroundColor = .systemBlue
        
        let padding: CGFloat = 20
        
        let itemViews = [headerView, itemViewOne, itemViewTwo]
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
        
        NetworkManager.shared.getUserData(for: username) { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.dismissLoadingView()
            
            switch(result) {
            case .success(let user):
                DispatchQueue.main.async {
                    self.add(childViewController: GFUserInfoHeaderViewController(user: user), to: self.headerView)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}
