//
//  AvatarsService.swift
//  github-followers
//
//  Created by Fedor Valiavko on 31/07/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import UIKit

final class AvatarsService: AvatarsServicing {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getAvatar(from urlString: String, handler: @escaping (Result<Avatar, GFError>) -> Void) {
        guard let url = URL(string: urlString) else {
            handler(.failure(.invalidUrl))
            return
        }
        
        apiClient.httpGet(url: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    handler(.failure(.invalidData))
                    return
                }

                handler(.success(Avatar(image: image)))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
