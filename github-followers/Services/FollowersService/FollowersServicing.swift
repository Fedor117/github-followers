//
//  FollowersServicing.swift
//  github-followers
//
//  Created by Fedor Valiavko on 31/07/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

protocol FollowersServicing {
    func getFollowers(for username: String, page: Int, handler: @escaping (Result<[Follower], GFError>) -> Void)
}
