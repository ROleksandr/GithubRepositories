//
//  String+Additions.swift
//  GithubRepositories
//
//  Created by Olexandr Rutenko on 9/13/18.
//  Copyright © 2018 Olexandr Rutenko. All rights reserved.
//

import Foundation

extension String {
    static func urlParamsStringEncoded(_ params: ParamsType) -> String? {
        if params.keys.count == 0 {
            return nil
        }
        var paramsArray: [String] = []
        for (key, value) in params {
            paramsArray.append(key + "=" + String(describing: value))
        }
        let paramsString = paramsArray.joined(separator: "&")
        debugPrint(paramsString)
        return paramsString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    func truncated(_ truncationLimit: Int) -> String {
        return String(prefix(truncationLimit))
    }
}
