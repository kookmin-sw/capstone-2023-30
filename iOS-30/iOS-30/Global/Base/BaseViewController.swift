//
//  BaseViewController.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/15.
//

import UIKit

class BaseViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func render() {
        // Override Layout
    }

    func configUI() {
        // View Configuration
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupBaseNavigationBar(backgroundColor: UIColor = .white,
                                titleColor: UIColor = .black,
                                isTranslucent: Bool = false,
                                tintColor: UIColor = .black) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let appearance = UINavigationBarAppearance()
        let font = UIFont.systemFont(ofSize: 16, weight: .medium)

        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [
            .foregroundColor: titleColor,
            .font: font
        ]
        appearance.shadowColor = .clear

        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = isTranslucent
        navigationBar.tintColor = tintColor
    }


}
