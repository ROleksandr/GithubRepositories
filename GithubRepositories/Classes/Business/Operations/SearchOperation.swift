//
//  SearchOperation.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/14/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

class SearchOperation: AsyncOperation {
    private let service = RepositoriesService()
    private let query: String
    private let page: Int
    var repositories: [Repository]?
    var error: ErrorBlock?
    init(query: String, page: Int) {
        self.query = query
        self.page = page
    }
    override func main() {
        service.getRepositories(text: query, page: page, success: { [weak self] page in
            self?.repositories = page.repositories
            self?.state = .finished
        }, error: { [weak self] errorString in
            self?.error?(errorString)
            self?.state = .finished
            debugPrint(errorString)
        })
    }
}
