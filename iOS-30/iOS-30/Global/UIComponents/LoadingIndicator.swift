//
//  LoadingIndicator.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/31.
//

import UIKit

final class LoadingIndicator {
    static func showLoading() {
        DispatchQueue.main.async {
            let window = UIApplication
                .shared
                .connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .last

            let loadingIndicatorView: LoadingView
            if let existedView = window?.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? LoadingView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = LoadingView()

                /// 다른 UI가 눌리지 않도록 indicatorView의 크기를 full로 할당
                loadingIndicatorView.frame = window?.frame ?? .zero
                window?.addSubview(loadingIndicatorView)
            }

            loadingIndicatorView.startAnimating()
        }
    }

    static func hideLoading() {
        let window = UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last

        DispatchQueue.main.async {
            window?.subviews.filter({ $0 is LoadingView })
                .forEach({
                    $0.removeFromSuperview()
                })
        }
    }
}
