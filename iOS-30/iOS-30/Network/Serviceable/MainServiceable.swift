//
//  MainServicable.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/15.
//

import Foundation

protocol MainServiceable {
    func postImage(imageSize: (Int, Int), name: String, body: Data?) async throws -> Int?
}
