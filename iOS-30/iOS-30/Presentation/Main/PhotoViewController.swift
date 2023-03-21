//
//  PhotoViewController.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/12.
//

import UIKit

final class PhotoViewController: UIViewController {

    // MARK: var & let

    private let picker = UIImagePickerController()

    // MARK: UI Components

    private lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .lightGray
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(openPhotoLibrary))
        )
        return img
    }()

    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("다음으로", for: .normal)
        btn.backgroundColor = .purple
        btn.layer.cornerRadius = 10
        btn.isHidden = true
        btn.addTarget(self, action: #selector(nextButtonDidTapped), for: .touchUpInside)
        return btn
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "사진을 추가해주세요 !"
        label.tintColor = .gray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setNavigationBar()
        render()
    }

    private func render() {
        view.addSubViews([imageView, nextButton])
        imageView.addSubview(emptyLabel)
        [imageView, nextButton, emptyLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        nextButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        emptyLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        emptyLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
    }

    private func setDelegate() {
        picker.delegate = self
    }

    private func setNavigationBar() {
        let cameraButton = UIBarButtonItem(
            image: UIImage(systemName: "camera.fill"),
            style: .plain,
            target: self,
            action: #selector(openCamera)
        )
        cameraButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = cameraButton
    }

    private func setPhotoImageView(image: UIImage) {
        imageView.image = image
        emptyLabel.isHidden = true
        nextButton.isHidden = false
    }
}

// MARK: Delegate

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            setPhotoImageView(image: image)
        }
        dismiss(animated: true)
    }
}

// MARK: Obj-C Methods

extension PhotoViewController {
    @objc private func openPhotoLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    @objc private func openCamera() {
        print("Opened Camera !")
    }

    @objc private func nextButtonDidTapped() {
        let filterViewController = FilterViewController()
        self.navigationController?.pushViewController(filterViewController, animated: false)
    }
}

