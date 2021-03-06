//
//  GFEmptyStateView.swift
//  github-followers
//
//  Created by Theodor Valiavko on 13/01/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import UIKit

final class GFEmptyStateView: UIView {
    private let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
    private let logoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(message: String) {
        self.init(frame: .zero)
        
        messageLabel.text = message
    }
    
    private func configure() {
        let subviews = [messageLabel, logoImageView]
        for subview in subviews {
            addSubview(subview)
        }

        configureMessageLabel()
        configureLogoImageView()
    }

    private func configureMessageLabel() {
      messageLabel.numberOfLines = 3
      messageLabel.textColor = .secondaryLabel
      
      let labelCenterYConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -50 : -150
      
      NSLayoutConstraint.activate([
          messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterYConstraintConstant),
          messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
          messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
          messageLabel.heightAnchor.constraint(equalToConstant: 200)
      ])
    }
    
    private func configureLogoImageView() {
      logoImageView.image = UIImage(named: ImageAssets.emptyStateLogo)
      logoImageView.translatesAutoresizingMaskIntoConstraints = false
      
      let logoBottomConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 100 : 40
      
      NSLayoutConstraint.activate([
          logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
          logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
          logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
          logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: logoBottomConstraintConstant)
      ])
    }
}
