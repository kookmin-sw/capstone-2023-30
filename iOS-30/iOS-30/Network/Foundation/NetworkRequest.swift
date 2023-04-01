//
//  NetworkResult.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/15.
//

import Foundation

struct NetworkRequest {
    let httpMethod: HttpMethod
    let url: String
    let headers: [String: String]?
    let body: Data?
    let requestTimeout: Float?

    func buildURLRequest(with url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = headers ?? [:]
        urlRequest.httpBody = body
        return urlRequest
    }
}
