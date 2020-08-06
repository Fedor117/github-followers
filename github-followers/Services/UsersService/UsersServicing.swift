//
//  UsersServicing.swift
//  github-followers
//
//  Created by Fedor Valiavko on 31/07/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

protocol UsersServicing {
    func getUser(for username: String, handler: @escaping (Result<User, GFError>) -> Void)
}
