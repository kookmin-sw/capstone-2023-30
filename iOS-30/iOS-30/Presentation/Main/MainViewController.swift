//
//  MainViewController.swift
//  iOS-30
//
//  Created by 김민재 on 2023/03/22.
//

import AVFoundation
import UIKit


final class MainViewController: UIViewController {

    // MARK: Var & let
    // Capture Session
    var session: AVCaptureSession?
    // Photo Output
    let output = AVCapturePhotoOutput()
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    //
    private let picker = UIImagePickerController()

    private var selectedFilterIndex: Int?

    //MARK: UI Components

    private let currentFilterLabel: BasePaddingLabel = {
        let label = BasePaddingLabel(padding: .init(top: 5, left: 5, bottom: 5, right: 5))
        label.text = "필터 이름"
        label.textAlignment = .center
        label.backgroundColor = .black
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemYellow
        label.clipsToBounds = true
        label.layer.cornerRadius = 6

        return label
    }()

    private let shutterButton: UIButton = {
        let button = UIButton(
            frame: CGRect(x: 0, y: 0, width: 100, height: 100)
        )
        button.layer.borderWidth = 5
        button.layer.cornerRadius = 50
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    private lazy var changeDirectionButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "arrow.triangle.2.circlepath")
        config.contentInsets = .zero
        config.baseForegroundColor = .white
//        config.baseBackgroundColor = .systemYellow
//        button.layer.cornerRadius = 10
//        button.setImage(UIImage(
//            systemName: "arrow.triangle.2.circlepath"), for: .normal)
//        button.layer.borderWidth = 3
//        button.layer.borderColor = UIColor.white.cgColor
//        button.tintColor = .white
        button.configuration = config
        button.addTarget(
            self,
            action: #selector(didTapChangeButton),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setImage(UIImage(systemName: "camera.filters"), for: .normal)
        button.contentMode = .scaleToFill
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .lightGray
        button.tintColor = .black
        button.addTarget(
            self,
            action: #selector(didTapFilterButton),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var albumButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.setImage(UIImage(systemName: "photo.fill"), for: .normal)
        button.contentMode = .scaleToFill
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .lightGray
        button.tintColor = .black
        button.addTarget(
            self,
            action: #selector(didTapAlbumButton),
            for: .touchUpInside
        )
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        configUI()
        render()
        setShutterButton()
        checkCameraPermission()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global().async {
            self.session?.startRunning()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint(
            x: view.frame.size.width / 2,
            y: view.frame.size.height - 200
        )
    }

    private func setDelegate() {
        picker.delegate = self
    }

    private func render() {
        view.layer.addSublayer(previewLayer)
        view.addSubViews([
                shutterButton,
                filterButton,
                albumButton,
                changeDirectionButton,
                currentFilterLabel])
        [
            filterButton,
            albumButton,
            changeDirectionButton,
            currentFilterLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        currentFilterLabel.centerXAnchor.constraint(equalTo: shutterButton.centerXAnchor).isActive = true
        currentFilterLabel.bottomAnchor.constraint(equalTo: shutterButton.topAnchor, constant: -20).isActive = true

        changeDirectionButton.centerXAnchor.constraint(equalTo: shutterButton.centerXAnchor).isActive = true
        changeDirectionButton.centerYAnchor.constraint(equalTo: filterButton.centerYAnchor).isActive = true
        changeDirectionButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        changeDirectionButton.widthAnchor.constraint(equalTo: filterButton.heightAnchor).isActive = true


        filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        filterButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        filterButton.widthAnchor.constraint(equalTo: filterButton.heightAnchor).isActive = true

        let albumConstraint = [
            albumButton.centerYAnchor.constraint(equalTo: filterButton.centerYAnchor),
            albumButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            albumButton.heightAnchor.constraint(equalToConstant: 60),
            albumButton.widthAnchor.constraint(equalTo: albumButton.heightAnchor)
        ]
        NSLayoutConstraint.activate(albumConstraint)
    }

    private func configUI() {
        view.backgroundColor = .black
    }

    private func setShutterButton() {
        shutterButton.addTarget(
            self,
            action: #selector(didTapShutterButton),
            for: .touchUpInside
        )
    }

    private func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                // Permission 요청
                let granted = await AVCaptureDevice.requestAccess(for: .video)
                if granted {
                    setUpCamera()
                }
            case .restricted:
                break
            case .denied:
                break
            case .authorized:
                setUpCamera()
            @unknown default:
                break
            }
        }
    }

    @MainActor
    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            // try to create input from the device
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }

                if session.canAddOutput(output) {
                    session.addOutput(output)
                }

                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                DispatchQueue.global().async {
                    session.startRunning()
                }
                self.session = session // retain the session into our global

            } catch {
                print(error)
            }
        }
    }

    private func camera(in position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera],
            mediaType: .video,
            position: .unspecified
        )

        let devices = discoverySession.devices
        guard !devices.isEmpty else { fatalError("Missing Capture Devices") }

        return devices.first { device in
            device.position == position
        }
    }
}

// MARK: Obj-C Methods

extension MainViewController {
    @objc private func didTapShutterButton() {
        makeVibrate(degree: .heavy)
        output.capturePhoto(
            with: AVCapturePhotoSettings(),
            delegate: self
        )
    }

    @objc private func didTapChangeButton() {
        session?.beginConfiguration()
        guard let currentInput = session?.inputs.first as? AVCaptureDeviceInput
        else {
            return
        }
        session?.removeInput(currentInput)

        guard let newCameraDevice = currentInput.device.position == .back ? camera(in: .front) : camera(in: .back)
        else {
            print("newCameraDevice")
            return
        }
        guard let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice) else {
            print("newVideoInput")
            return
        }
        session?.addInput(newVideoInput)
        session?.commitConfiguration()
    }

    @objc private func didTapFilterButton() {
        let filterVC = FilterViewController()
        filterVC.modalPresentationStyle = .fullScreen
        filterVC.completion = { filter, index in
            self.selectedFilterIndex = index
            self.currentFilterLabel.text = filter.name
        }
        filterVC.selectedIndex = selectedFilterIndex
        self.present(filterVC, animated: true)
    }

    @objc private func didTapAlbumButton() {
        picker.sourceType = .photoLibrary
        picker.modalPresentationStyle = .overFullScreen
        self.present(picker, animated: true)
    }
}

// MARK: Delegate

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            makePLYwithImage(image: image, error: nil)
        }
        dismiss(animated: true)
    }
}

extension MainViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        // AVCapturePhoto: AVFoundation version of photo output
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data)
        else {
            return
        }
//        image = image.resize(to: CGSize(width: image.size.height, height: image.size.width))
        makePLYwithImage(image: image, error: error)
    }

    private func makePLYwithImage(image: UIImage, error: Error?) {
//        let image = image.resize(to: CGSize(width: image.size.height, height: image.size.width))
        session?.stopRunning()

        // 네트워크 통신 시작 ! 보내기 비동기 보내고 lottie 돌리기
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        print(width, height)
//        guard let url = URL(string: "https://3qt14ezkgb.execute-api.ap-northeast-2.amazonaws.com/img/test/request/\(width)x\(height)?img_name=\(arc4random()).jpeg") else {
//            print("url fail")
//            return
//
//        }

        guard let url = URL(string: "http://angheng.iptime.org:1398/request/?img_name=\(arc4random()).jpeg") else {
            print("url fail")
            return

        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")

        guard let jpegImage = image.jpegData(compressionQuality: 0.5) else {
            print("jpeg transform fail")
            return
        }

        Task {
            do {


                let sessionConfig = URLSessionConfiguration.default
                sessionConfig.timeoutIntervalForRequest = .greatestFiniteMagnitude
                sessionConfig.timeoutIntervalForResource = .greatestFiniteMagnitude
                let session = URLSession(configuration: sessionConfig)

                let (data, response) = try await session
                    .upload(for: urlRequest, from: jpegImage)
                guard let responseCode = (response as? HTTPURLResponse)?.statusCode,
                      responseCode == 200 else {
                    print("response !!!!")
                    print(response)
                    if let error {
                        print("Error !!!!")
                        print(error)
                    }
                    return
                }

                print("🚀🚀🚀🚀🚀🚀🚀")
                dump(data)
                let directoryURL = FileManager
                    .default
                    .urls(for: .documentDirectory,
                          in: .userDomainMask)[0]
                let fileURL = URL(fileURLWithPath: "myPLY", relativeTo: directoryURL).appendingPathExtension("ply")

                try? data.write(to: fileURL)
                print("File saved: \(fileURL.absoluteURL)")

                LoadingIndicator.hideLoading()
                let viewController = SceneViewController()
                viewController.fileURL = fileURL
                self.navigationController?.pushViewController(viewController, animated: true)

            } catch {
                print(error.localizedDescription)
            }
        }

        LoadingIndicator.showLoading()

    }
}
