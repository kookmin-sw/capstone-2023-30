//
//  EndPointable.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/31.
//

import Foundation

protocol EndPointable {
    var requestTimeout: Float { get }
    var httpMethod: HttpMethod { get }
    var requestBody: Data? { get }
    func getURL(baseURL: String) -> String
}
