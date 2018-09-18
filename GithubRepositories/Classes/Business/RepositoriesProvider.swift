//
//  RepositoriesProvider.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/14/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

protocol RepositoriesSearchProtocol {
    func search(query: String, completion: @escaping (Result<[Repository]>) -> Void)
    func cancelSearch()
}

final class RepositoriesProvider: NSObject, RepositoriesSearchProtocol {
    private let totalThreads = 2
    private lazy var operationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = totalThreads
        return queue
    }()
    func search(query: String, completion: @escaping (Result<[Repository]>) -> Void) {
        operationQueue.cancelAllOperations()
        var results: [Repository] = []
        for page in 1...totalThreads {
            let operation = SearchOperation(query: query, page: page)
            operation.error = { errorString in
                completion(.error(errorString))
            }
            operation.completionBlock = { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                if operation.isCancelled {
                    return
                }
                results = strongSelf.add(newValue: operation.repositories ?? [], to: results)
                if self?.operationQueue.operationCount == 0 {
                  completion(.success(results))
                }
            }
            operationQueue.addOperation(operation)
        }
    }
    func cancelSearch() {
        operationQueue.cancelAllOperations()
    }
    fileprivate func add(newValue:[Repository], to oldValue: [Repository]) -> [Repository] {
        guard let oldValueLast = oldValue.last else {
            return newValue
        }
        guard let newValueFirst = newValue.first else {
            return oldValue
        }
        var repositories: [Repository] = []
        if oldValueLast.starsCount > newValueFirst.starsCount {
            repositories = oldValue + newValue
        } else {
            repositories = newValue + oldValue
        }
        return repositories
    }
}
