//
//  GFAlertContainerView.swift
//  github-followers
//
//  Created by Theodor Valiavko on 06/01/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import UIKit

final class GFAlertContainerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
