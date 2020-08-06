//
//  FavoritesServicing.swift
//  github-followers
//
//  Created by Fedor Valiavko on 06/08/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

protocol FavoritesServicing {
    var favorites: [Follower] { get }
    func addToFavorites(follower: Follower)
    func removeFromFavorites(follower: Follower)
}
