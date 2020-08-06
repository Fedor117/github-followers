//
//  User.swift
//  github-followers
//
//  Created by Theodor Valiavko on 06/01/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import Foundation

struct User: Codable {

    let login: String
    let avatarUrl: String
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: Date
    var name: String?
    var location: String?
    var bio: String?
}
