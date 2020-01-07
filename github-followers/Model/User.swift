//
//  User.swift
//  github-followers
//
//  Created by Theodor Valiavko on 06/01/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import Foundation

struct User: Codable {

    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var htmlUrl: String
    var following: Int
    var followers: Int
    var createdAt: String
}
