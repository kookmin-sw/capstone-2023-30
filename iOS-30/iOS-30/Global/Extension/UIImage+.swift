//
//  UIImage+.swift
//  iOS-30
//
//  Created by 김민재 on 2023/05/19.
//

import UIKit

extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
