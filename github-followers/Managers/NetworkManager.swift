//
//  NetworkManager.swift
//  github-followers
//
//  Created by Theodor Valiavko on 06/01/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import UIKit

final class NetworkManager {

    static let shared = NetworkManager()

    private let cache = NSCache<NSString, UIImage>()
    private let decoder: JSONDecoder
    private let baseURL = "https://api.github.com/users/"
    
    private init() {
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func downloadImage(from urlString: String, completed: @escaping (Result<UIImage, GFError>) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(.success(image))
            return
        }
        
        getData(endpoint: urlString) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completed(.failure(.invalidData))
                    return
                }
                
                self.cache.setObject(image, forKey: cacheKey)
                completed(.success(image))

            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
    
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GFError>) -> Void) {
        let endpoint = baseURL + "\(username)/followers?per_page=\(Config.numberOfItemsPerPage)&page=\(page)"
        
        getData(endpoint: endpoint) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let data):
                do {
                    let followers = try self.decoder.decode([Follower].self, from: data)
                    completed(.success(followers))
                } catch {
                    completed(.failure(.invalidData))
                }
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
    
    func getUserData(for username: String, completed: @escaping (Result<User, GFError>) -> Void) {
        let endpoint = baseURL + "\(username)"

        getData(endpoint: endpoint) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let data):
                do {
                    let user = try self.decoder.decode(User.self, from: data)
                    completed(.success(user))
                } catch {
                    completed(.failure(.invalidData))
                }
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
    
    private func getData(endpoint: String, completionHandler: @escaping (Result<Data, GFError>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completionHandler(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completionHandler(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            completionHandler(.success(data))
        }
        task.resume()
    }
}
