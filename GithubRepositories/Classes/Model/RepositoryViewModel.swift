//
//  RepositoryViewModel.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/13/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import UIKit

fileprivate let truncationLimit = 30

struct RepositoryViewModel {
    let name: String
    let starsCount: Int
    let url: URL
}

extension RepositoryViewModel {
    init(_ repository: Repository) {
        name = repository.name.truncated(truncationLimit)
        starsCount = repository.starsCount
        url = repository.url
    }
}
