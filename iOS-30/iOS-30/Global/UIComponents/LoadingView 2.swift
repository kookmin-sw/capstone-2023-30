//
//  LoadingView.swift
//  iOS-30
//
//  Created by 김민재 on 2023/04/01.
//

import UIKit
import Lottie

final class LoadingView: UIView {

    private let loadingLottie: LottieAnimationView = {
        let view = LottieAnimationView(name: "loading")
        view.loopMode = .loop
        view.play()
        return view
    }()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .black
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("Not Implemented")
    }

    private func setupView() {
        loadingLottie.translatesAutoresizingMaskIntoConstraints = false
        self.addSubView(loadingLottie)

        NSLayoutConstraint.activate([
            loadingLottie.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingLottie.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            loadingLottie.heightAnchor.constraint(equalToConstant: 400),
            loadingLottie.widthAnchor.constraint(equalTo: loadingLottie.heightAnchor)
        ])
    }

    func startAnimating() {
        loadingLottie.play()
    }

    func stopAnimating() {
        loadingLottie.stop()
    }
}

