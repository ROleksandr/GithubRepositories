//
//  Resource.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/13/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

typealias ParamsType = [String: Any]

struct Resource {
    let endpoint: URL
    let path: String
    let params: ParamsType?
    init(endpoint: URL, path: String, params: ParamsType? = nil) {
        self.endpoint = endpoint
        self.path = path
        self.params = params
    }
}

extension Resource {
    func buildRequest() -> URLRequest? {
        guard let url = buildUrl() else {
            return nil
        }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        return request as URLRequest
    }
    
    private func buildUrl() -> URL? {
        var finalUrl = endpoint.appendingPathComponent(path)
        if let params = params,
            let paramsString = String.urlParamsStringEncoded(params),
            let newUrl = URL(string: finalUrl.absoluteString + "?" + paramsString) {
            finalUrl = newUrl
        }
        return finalUrl
    }
}
