//
//  PersistenceManager.swift
//  github-followers
//
//  Created by Theodor Valiavko on 4/23/20.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import Foundation

class PersistenceManager {

    enum Keys {
        static let favorites = "favorites"
    }
    
    static let shared = PersistenceManager()

    private let defaults = UserDefaults.standard
    
    var favoriteFollowers: [Follower] {
        if let data = UserDefaults.standard.value(forKey: PersistenceManager.Keys.favorites) as? Data {
            let followers = try? PropertyListDecoder().decode([Follower].self, from: data)
            return followers ?? []
        }
        return []
    }
    
    private init() {}
    
    func addToFavorites(follower: Follower) {
        var followers = favoriteFollowers
        if !followers.contains(follower) {
            followers.append(follower)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(followers), forKey: PersistenceManager.Keys.favorites)
        }
    }
    
    func removeFromFavorites(follower: Follower) {
        var followers = favoriteFollowers
        if followers.contains(follower) {
            followers = followers.filter { $0.login != follower.login }
            UserDefaults.standard.set(try? PropertyListEncoder().encode(followers), forKey: PersistenceManager.Keys.favorites)
        }
    }
    
    func isAlreadyFavorite(follower: Follower) -> Bool {
        return favoriteFollowers.contains(follower)
    }
}
