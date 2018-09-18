//
//  RepositoriesDataManager.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/13/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

protocol PostDataProtocol {
    var onDidLoadRepositories: (() -> ())? { get set }
    var onDidUpdateLoading: ((_ loading: Bool) -> ())? { get set }
    var onError: ErrorBlock? { get set }
    var onNoResults: (() -> ())? { get set }
    func search(_ query: String)
    func cancelSearch()
    var numberOfCells: Int { get }
    func repositoryCellViewModel(at indexPath: IndexPath) -> RepositoryViewModel
}

final class RepositoriesDataManager: PostDataProtocol {
    var onDidLoadRepositories: (() -> ())?
    var onError: ErrorBlock?
    var onNoResults: (() -> ())?
    var onDidUpdateLoading: ((_ loading: Bool) -> ())?
    private let provider = RepositoriesProvider()
    private var loading: Bool = false {
        didSet {
            onDidUpdateLoading?(loading)
        }
    }
    private var repositories = [Repository]() {
        didSet {
            onDidLoadRepositories?()
        }
    }
    func search(_ query: String) {
        if query.isEmpty {
            cancelSearch()
            return
        }
        loading = true
        provider.search(query: query) { [weak self] result in
            self?.loading = false
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                if repositories.count == 0 {
                    self?.onNoResults?()
                }
            case .error(let errorString):
                self?.repositories = []
                self?.onError?(errorString)
            }
        }
    }
    func cancelSearch() {
        loading = false
        provider.cancelSearch()
        repositories.removeAll()
    }
    func saveRepository(at indexPath: IndexPath) {
        let storage = Storage.shared
        storage.saveRepository(repositories[indexPath.row])
    }
    var numberOfCells: Int {
        return repositories.count
    }
    func repositoryCellViewModel(at indexPath: IndexPath) -> RepositoryViewModel {
        return RepositoryViewModel(repositories[indexPath.row])
    }
}

