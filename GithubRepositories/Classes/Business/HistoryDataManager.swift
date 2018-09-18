//
//  HistoryDataManager.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/17/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation
protocol HistoryDataProtocol {
    var onDidLoadRepositories: (() -> ())? { get set }
    func loadRecentRepositories()
    func removeAll()
    var numberOfCells: Int { get }
    func repositoryCellViewModel(at indexPath: IndexPath) -> RepositoryViewModel
}
final class HistoryDataManager: HistoryDataProtocol {
    var onDidLoadRepositories: (() -> ())?
    private let storage = Storage.shared
    private var repositories = [Repository]() {
        didSet {
            onDidLoadRepositories?()
        }
    }
    init() {
        storage.onDidLoadRepositories = { [weak self] in
            self?.loadRecentRepositories()
        }
    }
    func loadRecentRepositories() {
       repositories = storage.loadRecentRepositories()
    }
    func removeAll() {
        storage.removeAll()
    }
    var numberOfCells: Int {
        return repositories.count
    }
    func repositoryCellViewModel(at indexPath: IndexPath) -> RepositoryViewModel {
        return RepositoryViewModel(repositories[indexPath.row])
    }
}
