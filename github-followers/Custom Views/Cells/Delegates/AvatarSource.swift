//
//  AvatarSource.swift
//  github-followers
//
//  Created by Fedor Valiavko on 06/08/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

protocol AvatarDataSource {
    func getAvatar(for urlString: String, then handler: @escaping (Result<Avatar, GFError>) -> Void)
}
