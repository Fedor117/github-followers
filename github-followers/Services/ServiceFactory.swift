//
//  ServiceFactory.swift
//  github-followers
//
//  Created by Fedor Valiavko on 06/08/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

protocol ServiceFactory {
    func makeNetworkService() -> NetworkServicing
    func makeCacheService() -> CacheServicing
    func makeFollowersService(apiClient: APIClient) -> FollowersServicing
    func makeUsersService(apiClient: APIClient) -> UsersServicing
    func makeAvatarsService(apiClient: APIClient) -> AvatarsServicing

    func makeManagedDataService(usersService: UsersServicing,
                                followersService: FollowersServicing,
                                avatarService: AvatarsServicing,
                                cacheService: CacheServicing)
        -> ManagedDataServicing
}
