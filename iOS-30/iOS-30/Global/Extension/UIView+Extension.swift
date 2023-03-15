//
//  UIView+Extension.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/15.
//

import UIKit

extension UIView {
    func addSubView<T: UIView>(_ subview: T, completionHandler closure: ((T) -> Void)? = nil) {
        addSubview(subview)
        closure?(subview)
    }

    func addSubViews<T: UIView>(_ subviews: [T], completionHandler closure: (([T]) -> Void)? = nil) {
        subviews.forEach { addSubview($0) }
        closure?(subviews)
    }
}
