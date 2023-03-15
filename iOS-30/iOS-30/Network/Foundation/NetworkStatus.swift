//
//  NetworkStatus.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/15.
//

import Foundation

enum NetworkStatus: Int {
    case okay = 200
    case badRequest = 400
    case unAuthorized = 401
    case notFound = 404
    case internalServerError = 500
}
