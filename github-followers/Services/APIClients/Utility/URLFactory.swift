//
//  URLConstructing.swift
//  github-followers
//
//  Created by Fedor Valiavko on 02/08/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

protocol URLFactory {
    func makeUrl(baseUrl: URLComponents, with path: String, query: [String : String?]?) -> URL?
}
