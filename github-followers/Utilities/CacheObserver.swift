//
//  CacheObserver.swift
//  github-followers
//
//  Created by Theodor Valiavko on 5/10/20.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import Foundation

protocol CacheObserver: class {
    associatedtype Key: Hashable
    associatedtype Value
    
    func cache(_ cache: Cache<Key, Value>, didInsertedValueFor key: Key)
}

class GFCacheObserver<Key: Hashable, Value> {
    func cache(_ cache: Cache<Key, Value>, didInsertedValueFor key: Key) {
        
    }
}
