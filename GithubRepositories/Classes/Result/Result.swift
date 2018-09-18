//
//  Result.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/14/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

enum Result<T> {
    case error(String)
    case success(T)
}
