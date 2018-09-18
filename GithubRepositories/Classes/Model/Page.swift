//
//  Page.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/13/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

struct Page: Decodable {
    let repositories: [Repository]?
    enum DataKey: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataKey.self)
        repositories = try container.decodeIfPresent([Repository].self,
                                         forKey: .items)
    }
}
