//
//  RepositoriesService.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/13/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

class RepositoriesService {
    let baseUrl = URL(string: "https://api.github.com/")!
    private let network: Network
    init(network: Network) {
        self.network = network
    }
    convenience init() {
        self.init(network: NetworkManager())
    }
    func getRepositories(text: String, page: Int, success: @escaping (Page) -> Void, error errorCallback: @escaping ErrorBlock) {
        let params: ParamsType = ["q": text, "sort": "stars", "per_page": 15, "page": page]
        let resource = Resource(endpoint: baseUrl, path: "search/repositories", params: params)
        network.sendRequest(withResource: resource, success: { (data) in
            DispatchQueue.main.async {
                success(data)
            }
        }, error: { (errorString) in
            DispatchQueue.main.async {
                errorCallback(errorString)
            }
        })
    }
}
