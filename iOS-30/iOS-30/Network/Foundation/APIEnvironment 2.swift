//
//  APIEnvironment.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/31.
//

import Foundation

enum APIEnvironment: String {
    case develop
}

extension APIEnvironment {
    var baseURL: String {
        switch self {
        case .develop:
            return "https://3qt14ezkgb.execute-api.ap-northeast-2.amazonaws.com/img/test/request"
        }
    }

    var token: String {
        return ""
    }
}
