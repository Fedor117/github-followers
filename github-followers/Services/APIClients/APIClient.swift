//
//  APIClient.swift
//  github-followers
//
//  Created by Fedor Valiavko on 31/07/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

protocol APIClient {
    var baseUrl: URLComponents { get }
    
    func httpGet(url: URL, handler: @escaping (Result<Data, GFError>) -> Void)
}
