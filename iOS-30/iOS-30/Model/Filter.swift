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
    let filterNum: Int
}


extension Filter {
    static func dummy() -> [Filter] {
        return [
            Filter(image: UIImage(systemName: "x.square")!, name: "No filter", filterNum: -1),
            Filter(image: .filter3, name: "깃털 무늬", filterNum: 3),
            Filter(image: .filter14, name: "고흐의 별이 빛나는 밤", filterNum: 14),
            Filter(image: .filter15, name: "은하", filterNum: 15),
            Filter(image: .filter19, name: "가나가와 해변의 높은 파도", filterNum: 19),
            Filter(image: .filter30, name: "Collioure 항구", filterNum: 30),
            Filter(image: .filter66, name: "Landscape with Goats", filterNum: 66),
            Filter(image: .filter86, name: "Voo de Aves", filterNum: 86)
        ]
    }
}
