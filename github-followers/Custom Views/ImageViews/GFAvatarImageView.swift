//
//  GFAvatarImageView.swift
//  github-followers
//
//  Created by Theodor Valiavko on 11/01/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import UIKit

final class GFAvatarImageView: UIImageView {

    private static let placeholderImage = UIImage(named: ImageAssets.avatarPlaceholder)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(urlString: String) {
        image = GFAvatarImageView.placeholderImage

        NetworkManager.shared.downloadImage(from: urlString) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.image = image
                }
                break
            case .failure(_):
                // Just leave the placeholder image
                break
            }
        }
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = GFAvatarImageView.placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
}
