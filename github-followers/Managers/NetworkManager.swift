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
    private var currentTasks = [String: URLSessionDataTask]()
    
    private var baseUrl: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.github.com"
        return urlComponents
    }
    
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
        
        guard let url = URL(string: urlString) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        getData(url: url) { [weak self] result in
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
        guard let url = makeUrl(with: "/users/\(username)/followers", query: ["per_page": "\(Config.numberOfItemsPerPage)", "page": String(page)]) else {
                completed(.failure(.invalidUrl))
                return
        }
        
        getDecodedData(url: url, type: [Follower].self) { result in
            switch result {
            case .success(let followers):
                completed(.success(followers))
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
    
    func getUserData(for username: String, completed: @escaping (Result<User, GFError>) -> Void) {
        guard let url = makeUrl(with: "/users/\(username)") else {
                completed(.failure(.invalidUrl))
                return
        }
        
        getDecodedData(url: url, type: User.self) { result in
            switch result {
            case .success(let user):
                completed(.success(user))
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }

    func cancelTask(for urlString: String) {
        if let currentTask = currentTasks[urlString], URLSessionDataTask.State.canceling != currentTask.state {
            currentTask.cancel()
            
        }
    }
    
    private func getDecodedData<T: Codable>(url: URL, type: T.Type, completed: @escaping (Result<T, GFError>) ->Void) {
        getData(url: url) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let data):
                do {
                    let user = try self.decoder.decode(type, from: data)
                    completed(.success(user))
                } catch {
                    completed(.failure(.invalidData))
                }
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
    
    private func getData(url: URL, completionHandler: @escaping (Result<Data, GFError>) -> Void) {
        let urlString = url.absoluteString

        // In case we have already requested data
        cancelTask(for: urlString)
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else {
                return
            }
            
            self.currentTasks.removeValue(forKey: urlString)
            
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

        currentTasks[urlString] = task
        task.resume()
    }
    
    private func makeUrl(with path: String, query: [String: String]? = nil) -> URL? {
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
