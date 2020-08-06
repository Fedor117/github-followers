//
//  GitHubAPIClient.swift
//  github-followers
//
//  Created by Fedor Valiavko on 31/07/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

final class GitHubAPIClient: APIClient {
    private let networkService: NetworkServicing
    
    init(networkService: NetworkServicing) {
        self.networkService = networkService
    }
    
    var baseUrl: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.github.com"
        return urlComponents
    }
    
    func httpGet(url: URL, handler: @escaping (Result<Data, GFError>) -> Void) {
        networkService.getData(from: url, handler: handler)
    }
}
