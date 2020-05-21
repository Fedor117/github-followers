//
//  NetworkManager.swift
//  github-followers
//
//  Created by Theodor Valiavko on 06/01/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import UIKit

final class NetworkManager {
    typealias DataHandler = ((Result<Data, GFError>) -> Void)

    static let shared = NetworkManager()

    private let cache = Cache<NSString, UIImage>()
    private let decoder: JSONDecoder
    
    private var currentTasks: [URL: URLSessionDataTask] = [:]
    private var pendingHandlers: [URL: [(Result<Data, GFError>) -> Void]] = [:]
    
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
    
    func prefetchImage(from urlString: String) {
        let cacheKey = NSString(string: urlString)
        if let _ = cache[cacheKey] {
            return
        }

        guard let url = URL(string: urlString) else {
            return
        }

        getData(fromUrl: url) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    self.cache[cacheKey] = image
                }
            case .failure(_):
                break
            }
        }
    }

    func getImage(from urlString: String, then completed: @escaping (Result<UIImage, GFError>) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache[cacheKey] {
            completed(.success(image))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(.failure(.invalidUrl))
            return
        }
        
        getData(fromUrl: url) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completed(.failure(.invalidData))
                    return
                }
                
                self.cache[cacheKey] = image
                completed(.success(image))

            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
    
    func getFollowers(for username: String, page: Int, then completed: @escaping (Result<[Follower], GFError>) -> Void) {
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
    
    func getUserData(for username: String, then completed: @escaping (Result<User, GFError>) -> Void) {
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
        URLSession.shared.getTasksWithCompletionHandler { [weak self] (dataTasks, uploadTasks, downloadTasks) in
            guard let self = self else {
                return
            }
            
            for dataTask in dataTasks {
                guard let url = dataTask.currentRequest?.url else {
                    continue
                }
                
                if url.absoluteString == urlString {
                    self.currentTasks.removeValue(forKey: url)
                    self.pendingHandlers.removeValue(forKey: url) // No need to pass an error to handlers
                    
                    dataTask.cancel()
                }
            }
        }
    }
    
    private func getDecodedData<T: Codable>(url: URL, type: T.Type, then completed: @escaping (Result<T, GFError>) ->Void) {
        getData(fromUrl: url) { [weak self] result in
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
    
    private func getData(fromUrl url: URL, then completed: @escaping (Result<Data, GFError>) -> Void) {
        if currentTasks[url] != nil {
            addDataHandlerToPendgingQueue(completed, for: url)
            return
        }
 
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else {
                return
            }
            
            self.currentTasks.removeValue(forKey: url)

            guard let handlers = self.pendingHandlers[url] else {
                return
            }
            
            if let _ = error {
                for handler in handlers {
                    handler(.failure(.unableToComplete))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                for handler in handlers {
                    handler(.failure(.unableToComplete))
                }
                return
            }
            
            guard let data = data else {
                for handler in handlers {
                    handler(.failure(.unableToComplete))
                }
                return
            }
            
            for handler in handlers {
                handler(.success(data))
            }
            
            self.pendingHandlers.removeValue(forKey: url)
        }
        
        addDataHandlerToPendgingQueue(completed, for: url)
        
        currentTasks[url] = task

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
    
    private func addDataHandlerToPendgingQueue(_ dataHandler: @escaping (Result<Data, GFError>) -> Void, for url: URL) {
        if var handlers = pendingHandlers[url] {
            handlers.append(dataHandler)
            pendingHandlers[url] = handlers
        } else {
            var handlers = [(Result<Data, GFError>) -> Void]()
            handlers.append(dataHandler)
            pendingHandlers[url] = handlers
        }
    }
}
