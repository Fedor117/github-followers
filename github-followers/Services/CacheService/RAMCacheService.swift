//
//  RAMCacheService.swift
//  github-followers
//
//  Created by Fedor Valiavko on 31/07/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import UIKit

final class RAMCacheService: CacheServicing {
    private let cache = Cache<String, Data>()
    
    func save(url: String, data: Data) {
        cache[url] = data
    }
    
    func read(url: String) -> Data? {
        return cache[url]
    }
}
