//
//  UIHelper.swift
//  github-followers
//
//  Created by Theodor Valiavko on 12/01/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import UIKit

struct UIHelper {
    
    static func makeThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
           
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
           
        return flowLayout
    }
}
