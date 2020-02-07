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
    
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        layoutUI()

        getUserData()
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = doneBtn
    }
    
    private func layoutUI() {
        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
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
