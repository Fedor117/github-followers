//
//  FavoritesService.swift
//  github-followers
//
//  Created by Fedor Valiavko on 06/08/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

final class FavoritesService: FavoritesServicing {
    private let storage: UserDefaults
    private let encoder: PropertyListEncoder
    private let decoder: PropertyListDecoder
    
    init(storage: UserDefaults, encoder: PropertyListEncoder, decoder: PropertyListDecoder) {
        self.storage = storage
        self.encoder = encoder
        self.decoder = decoder
    }
    
    var favorites: [Follower] {
        if let data = storage.value(forKey: Keys.favorites) as? Data {
            let followers = try? decoder.decode([Follower].self, from: data)
            return followers ?? []
        }
        return []
    }
    
    func addToFavorites(follower: Follower) {
        var currentFavorites = favorites
        if !currentFavorites.contains(follower) {
            currentFavorites.append(follower)
            let encoded = try? encoder.encode(currentFavorites)
            storage.set(encoded, forKey: Keys.favorites)
        }
    }
    
    func removeFromFavorites(follower: Follower) {
        var currentFavorites = favorites
        if currentFavorites.contains(follower) {
            currentFavorites = currentFavorites.filter({ $0.login != follower.login })
            storage.set(currentFavorites, forKey: Keys.favorites)
        }
    }
    
    
}
