//
//  UserInfoViewController.swift
//  github-followers
//
//  Created by Theodor Valiavko on 14/01/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()

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
    
    private func getUserData() {
        showLoadingView()
        
        NetworkManager.shared.getUserData(for: username) { [weak self] result in
            guard let self = self else {
                return
            }
            
            self.dismissLoadingView()
            
            switch(result) {
            case .success(let user):
                self.updateData(with: user)
                break
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    private func updateData(with user: User) {
        #warning("Not implemented.")
    }
}
