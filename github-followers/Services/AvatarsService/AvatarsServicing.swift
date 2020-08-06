//
//  AvatarsServicing.swift
//  github-followers
//
//  Created by Fedor Valiavko on 31/07/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

protocol AvatarsServicing {
    func getAvatar(from urlString: String, handler: @escaping (Result<Avatar, GFError>) -> Void)
}
