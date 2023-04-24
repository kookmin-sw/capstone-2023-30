//
//  Filter.swift
//  iOS-30
//
//  Created by 김민재 on 2023/04/24.
//

import UIKit

struct Filter {
    let image: UIImage
    let name: String
    let description: String
}


extension Filter {
    static func dummy() -> [Filter] {
        return [
            Filter(image: .filter_1, name: "필터 1", description: "설명1"),
            Filter(image: .filter_2, name: "필터 2", description: "설명2"),
            Filter(image: .filter_3, name: "필터 3", description: "설명3"),
            Filter(image: .filter_4, name: "필터 4", description: "설명4"),
            Filter(image: .filter_5, name: "필터 5", description: "설명5"),
            Filter(image: .filter_6, name: "필터 6", description: "설명6"),
            Filter(image: .filter_7, name: "필터 7", description: "설명7")
        ]
    }
}
