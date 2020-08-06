//
//  FollowersService.swift
//  github-followers
//
//  Created by Fedor Valiavko on 31/07/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

final class FollowersService: FollowersServicing {
    private let apiClient: APIClient
    private let urlFactory: URLFactory
    private let decoder: JSONDecoder
    
    init(apiClient: APIClient, urlFactory: URLFactory, decoder: JSONDecoder) {
        self.apiClient = apiClient
        self.urlFactory = urlFactory
        self.decoder = decoder
    }
    
    func getFollowers(for username: String, page: Int, handler: @escaping (Result<[Follower], GFError>) -> Void) {
        let query = ["per_page": "\(Config.numberOfItemsPerPage)", "page": String(page)]
        guard let url = urlFactory.makeUrl(baseUrl: apiClient.baseUrl, with: "/users/\(username)/followers", query: query) else {
            handler(.failure(.invalidUrl))
            return
        }
        
        apiClient.httpGet(url: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let followers = try self.decoder.decode([Follower].self, from: data)
                    handler(.success(followers))
                } catch {
                    handler(.failure(.invalidData))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
