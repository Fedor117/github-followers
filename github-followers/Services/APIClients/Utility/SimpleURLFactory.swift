//
//  SimpleURLFactory.swift
//  github-followers
//
//  Created by Fedor Valiavko on 02/08/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

final class SimpleURLFactory: URLFactory {
    func makeUrl(baseUrl: URLComponents, with path: String, query: [String : String?]?) -> URL? {
        var urlComponents = baseUrl
        urlComponents.path = path
        
        if let query = query {
            var queryItems = [URLQueryItem]()
            
            for (key, value) in query {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            
            urlComponents.queryItems = queryItems
        }

        return urlComponents.url
    }
}
