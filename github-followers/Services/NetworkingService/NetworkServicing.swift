//
//  NetworkServicing.swift
//  github-followers
//
//  Created by Fedor Valiavko on 31/07/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

protocol NetworkServicing {
    func getData(from url: URL, handler: @escaping (Result<Data, GFError>) -> Void)
}
