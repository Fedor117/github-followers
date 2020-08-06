//
//  UsersService.swift
//  github-followers
//
//  Created by Fedor Valiavko on 31/07/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

final class UsersService: UsersServicing {
    private let apiClient: APIClient
    private let urlFactory: URLFactory
    private let decoder: JSONDecoder
    
    init(apiClient: APIClient, urlFactory: URLFactory, decoder: JSONDecoder) {
        self.apiClient = apiClient
        self.urlFactory = urlFactory
        self.decoder = decoder
    }
    
    func getUser(for username: String, handler: @escaping (Result<User, GFError>) -> Void) {
        guard let url = urlFactory.makeUrl(baseUrl: apiClient.baseUrl, with: "/users/\(username)", query: nil) else {
            handler(.failure(.invalidUrl))
            return
        }
        
        apiClient.httpGet(url: url) { [weak self] result in
            guard let self = self else {
                handler(.failure(.unableToComplete))
                return
            }
            
            switch result {
            case .success(let data):
                do {
                    let user = try self.decoder.decode(User.self, from: data)
                    handler(.success(user))
                } catch {
                    handler(.failure(.invalidData))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
