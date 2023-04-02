//
//  BaseModel.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/15.
//

import Foundation

struct BaseModel<T: Decodable>: Decodable {
    var status: Int
    var success: Bool
    var message: String
    var data: T?
}

struct emptyModel { }
