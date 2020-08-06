//
//  FollowerCell.swift
//  github-followers
//
//  Created by Theodor Valiavko on 11/01/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import UIKit

final class FollowerCell: UICollectionViewCell {
    private let avatarImageView = GFAvatarImageView(frame: .zero)
    private let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    var avatarUpdateDelegate: UserCellAvatarUpdateDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFollower(_ follower: Follower) {
        usernameLabel.text = follower.login
        
        avatarUpdateDelegate?.getAvatar(self, for: follower.avatarUrl)
    }
    
    private func configure() {
        let subviews = [avatarImageView, usernameLabel]
        for subview in subviews {
            addSubview(subview)
        }
        
        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

extension FollowerCell: UserCell {
    func updateAvatar(_ image: UIImage) {
        avatarImageView.image = image
    }
}
