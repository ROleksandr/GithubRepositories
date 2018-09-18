//
//  NetworkManager.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/13/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

typealias ErrorBlock = (String) -> Void
let limitReachedCode = 403

protocol Network {
    func sendRequest<T: Decodable>(withResource resource: Resource, success: @escaping (T) -> Void, error errorCallback: @escaping ErrorBlock)
}

class NetworkManager: Network {
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        return URLSession(configuration: configuration)
    }()
    
    func sendRequest<T: Decodable>(withResource resource: Resource, success: @escaping (T) -> Void, error errorCallback: @escaping ErrorBlock) {
        guard let urlRequest = resource.buildRequest() else {
            return
        }
        session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                errorCallback(error.localizedDescription)
                return
            }
            guard let data = data else {
                errorCallback("No data")
                return
            }
            if let status = (response as? HTTPURLResponse)?.statusCode,
                status == limitReachedCode {
                errorCallback("Limit reached")
                return
            }
            if let response = response, response.isValidResponse() {
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [])
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    success(result)
                } catch {
                    errorCallback("Invalid format")
                }
            } else {
                errorCallback("Incorrect response")
            }
        }.resume()
    }
}
