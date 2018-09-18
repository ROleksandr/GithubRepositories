//
//  Repository.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/13/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

struct Repository: Codable {
    let name: String
    let starsCount: Int
    let url: URL
    enum CodingKeys: String, CodingKey {
        case name
        case starsCount = "stargazers_count"
        case url = "html_url"
    }
}
