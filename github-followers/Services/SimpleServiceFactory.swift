//
//  SimpleServiceFactory.swift
//  github-followers
//
//  Created by Fedor Valiavko on 06/08/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

final class SimpleServiceFactory: ServiceFactory {
    func makeNetworkService() -> NetworkServicing {
        return NetworkService()
    }
    
    func makeCacheService() -> CacheServicing {
        return RAMCacheService()
    }
    
    func makeFavoritesService() -> FavoritesServicing {
        return FavoritesService(storage: UserDefaults.standard,
                                encoder: PropertyListEncoder(),
                                decoder: PropertyListDecoder())
    }
    
    func makeFollowersService(apiClient: APIClient) -> FollowersServicing {
        let followersDecoder = JSONDecoder()
        followersDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return FollowersService(apiClient: apiClient, urlFactory: SimpleURLFactory(), decoder: followersDecoder)
    }
    
    func makeUsersService(apiClient: APIClient) -> UsersServicing {
        let usersDecoder = JSONDecoder()
        usersDecoder.keyDecodingStrategy = .convertFromSnakeCase
        usersDecoder.dateDecodingStrategy = .iso8601

        return UsersService(apiClient: apiClient, urlFactory: SimpleURLFactory(), decoder: usersDecoder)
    }
    
    func makeAvatarsService(apiClient: APIClient) -> AvatarsServicing {
        return AvatarsService(apiClient: apiClient)
    }
    
    func makeManagedDataService(usersService: UsersServicing,
                                followersService: FollowersServicing,
                                avatarService: AvatarsServicing,
                                favoritesService: FavoritesServicing,
                                cacheService: CacheServicing)
        -> ManagedDataServicing {

        return ManagedDataService(usersService: usersService,
                                  followersService: followersService,
                                  avatarService: avatarService,
                                  favoritesService: favoritesService,
                                  cacheService: cacheService)
    }
}
