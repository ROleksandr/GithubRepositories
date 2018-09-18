//
//  Storage.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/17/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

private let repositoryKeyword = "Repositories"

class Storage {
    static let shared = Storage()
    private init() {
        getRepositories()
    }
    var onDidLoadRepositories: (() -> ())?
    private var repositories = [Repository]() {
        didSet {
            onDidLoadRepositories?()
            saveRepositories()
        }
    }
    func saveRepository(_ repository: Repository) {
        repositories.append(repository)
        debugPrint(repositories)
    }
    func loadRecentRepositories() -> [Repository] {
        return repositories
    }
    func removeAll() {
        repositories = []
    }
    fileprivate func getRepositories() {
        if let data = UserDefaults.standard.value(forKey: repositoryKeyword) as? Data,
            let savedRepositories = try? PropertyListDecoder().decode([Repository].self, from: data) {
            repositories = savedRepositories
        }
    }
    fileprivate func saveRepositories() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(repositories),
                                  forKey: repositoryKeyword)
    }
}
