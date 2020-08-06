//
//  ManagedDataService.swift
//  github-followers
//
//  Created by Fedor Valiavko on 03/08/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import UIKit

final class ManagedDataService: ManagedDataServicing {
    private let usersService: UsersServicing
    private let followersService: FollowersServicing
    private let avatarsService: AvatarsServicing
    private let favoritesService: FavoritesServicing
    private let cacheService: CacheServicing
    
    init(usersService: UsersServicing,
         followersService: FollowersServicing,
         avatarService: AvatarsServicing,
         favoritesService: FavoritesServicing,
         cacheService: CacheServicing) {
        self.usersService = usersService
        self.followersService = followersService
        self.avatarsService = avatarService
        self.favoritesService = favoritesService
        self.cacheService = cacheService
    }
    
    func getUser(for username: String, handler: @escaping (Result<User, GFError>) -> Void) {
        usersService.getUser(for: username, handler: handler)
    }
    
    func getFollowers(for username: String, page: Int, handler: @escaping (Result<[Follower], GFError>) -> Void) {
        followersService.getFollowers(for: username, page: page, handler: handler)
    }
    
    func getAvatar(from urlString: String, handler: @escaping (Result<Avatar, GFError>) -> Void) {
        if let data = cacheService.read(url: urlString) {
            if let image = UIImage(data: data) {
                handler(.success(Avatar(image: image)))
                return
            }
        }
        
        avatarsService.getAvatar(from: urlString) { [weak self] result in
            switch result {
            case .success(let avatar):
                guard let self = self else {
                    handler(result)
                    return
                }
                
                if let data = avatar.image.pngData() {
                    self.cacheService.save(url: urlString, data: data)
                }
                handler(result)
            case .failure(_):
                handler(result)
            }
        }
    }
    
    var favorites: [Follower] {
        return favoritesService.favorites
    }

    func addToFavorites(follower: Follower) {
        favoritesService.addToFavorites(follower: follower)
    }

    func removeFromFavorites(follower: Follower) {
        favoritesService.removeFromFavorites(follower: follower)
    }
}
