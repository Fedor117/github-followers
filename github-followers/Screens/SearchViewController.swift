//
//  SearchViewController.swift
//  github-followers
//
//  Created by Theodor Valiavko on 04/01/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    private let logoImageView = UIImageView()
    private let usernameTextField = GFTextField()
    private let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")

    var isUsernameEmpty: Bool {
        return usernameTextField.text?.isEmpty ?? true
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()

        view.addGestureRecognizer(makeDismissKeyboardTapGesture())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        usernameTextField.text = ""
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func makeDismissKeyboardTapGesture() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
    }
    
    private func configureLogoImageView() {
        view.addSubview(logoImageView)

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: ImageAssets.githubLogo)
        
        let topConstraintConstant: CGFloat = (DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed) ? 20 : 80
        let logoImageViewTopConstraint = logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant)
        
        NSLayoutConstraint.activate([
            logoImageViewTopConstraint,
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureTextField() {
        view.addSubview(usernameTextField)
        
        usernameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        
        callToActionButton.addTarget(self, action: #selector(pushFollowerListViewController), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func pushFollowerListViewController() {
        guard !isUsernameEmpty else {
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please, enter a username. We need to know who to look for 😀", buttonTitle: "Ok")
            return
        }

        usernameTextField.resignFirstResponder()

        navigationController?.pushViewController(FollowerListViewController(username: usernameTextField.text!), animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListViewController()
        return true
    }
}
