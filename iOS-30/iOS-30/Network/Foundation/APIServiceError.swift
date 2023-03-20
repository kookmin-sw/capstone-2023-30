//
//  APIServiceError.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/15.
//

import Foundation

enum APIServiceError: Error {
    case urlEncodingError
    case clientError(message: String?)
    case serverError
}
