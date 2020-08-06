//
//  AvatarDownloader.swift
//  github-followers
//
//  Created by Fedor Valiavko on 06/08/2020.
//  Copyright © 2020 Fedor Valiavko. All rights reserved.
//

import Foundation

final class ServiceDataSoruce: UserCellAvatarUpdateDelegate {
    private let dataService: ManagedDataServicing
    
    init(dataService: ManagedDataServicing) {
        self.dataService = dataService
    }
    
    func getAvatar(_ cell: UserCell, for urlString: String) {
        dataService.getAvatar(from: urlString) { result in
            switch result {
            case .success(let avatar):
                DispatchQueue.main.async {
                    cell.updateAvatar(avatar.image)
                }
            case .failure(_):
                break
            }
        }
    }
}
