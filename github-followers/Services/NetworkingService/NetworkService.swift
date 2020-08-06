//
//  NetworkService.swift
//  github-followers
//
//  Created by Fedor Valiavko on 31/07/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

final class NetworkService: NetworkServicing {
    private let urlSession = URLSession.shared
    
    func getData(from url: URL, handler: @escaping (Result<Data, GFError>) -> Void) {
        urlSession.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                handler(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                handler(.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                handler(.failure(.unableToComplete))
                return
            }
            
            handler(.success(data))
        }.resume()
    }
}
