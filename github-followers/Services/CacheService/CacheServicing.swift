//
//  CacheServicing.swift
//  github-followers
//
//  Created by Fedor Valiavko on 31/07/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

protocol CacheServicing {
    func save(url: String, data: Data)
    func read(url: String) -> Data?
}
