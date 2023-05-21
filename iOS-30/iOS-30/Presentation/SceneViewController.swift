//
//  SceneViewController.swift
//  iOS-30
//
//  Created by 김민재 on 2023/04/01.
//

import UIKit
import SceneKit

final class SceneViewController: UIViewController {

    private let sceneView = SCNView().then {
        $0.contentMode = .scaleAspectFill
    }

    var fileURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setLayout()
        setSceneView()
        readPLYFile()
    }

    private func readPLYFile() {
        do {
            guard let fileURL else {
                print("fileURL is nil")
                return
            }
            let savedData = try Data(contentsOf: fileURL)

        } catch {
            print("Unable to read the file")
        }

    }

    private func setStyle() {
        view.backgroundColor = .black
    }

    private func setLayout() {
        view.addSubview(sceneView)
        sceneView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SceneViewController {
    private func setSceneView() {
        // 1: Load .obj file
        guard let fileURL else {
            print("fileURL is nil")
            return
        }
        sceneView.allowsCameraControl = true
        sceneView.cameraControlConfiguration.panSensitivity = 0.001
        sceneView.cameraControlConfiguration.rotationSensitivity = 0.001
        let scene = try? SCNScene(url: fileURL)

//        let scene = SCNScene(named: "IMG_9274.ply")

        // 2: Add camera node
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()

        // 3: Place camera
        
        cameraNode.camera?.projectionDirection = .horizontal // axis
        cameraNode.camera?.fieldOfView = 43 // fov
//        cameraNode.transform = SCNMatrix4() // transform
//        cameraNode.
        // -0.01003696
        // -0.04567727
//        [ -1.0000000,  0.0000000,  0.0000000;
//           0.0000000,  1.0000000,  0.0000000;
//          -0.0000000,  0.0000000, -1.0000000 ]
//        cameraNode.transform = .init(
//            m11: -1, m12: 0, m13: 0, m14: 0,
//            m21: 0, m22: 1, m23: 0, m24: 0,
//            m31: 0, m32: 0, m33: -1, m34: 0,
//            m41: 0, m42: 0, m43: 0, m44: 1
//        )

        cameraNode.transform = .init(
            m11: 1, m12: 0, m13: 0, m14: 0,
            m21: 0, m22: -1, m23: 0, m24: 0,
            m31: 0, m32: 0, m33: -1, m34: 0,
            m41: 0, m42: 0, m43: 0, m44: 1
        )

        cameraNode.camera?.zNear = 0

//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10) // position 카메라 위치
//        cameraNode.rotate(by: .init(0, 1, 0, 0), aroundTarget: .)
//        cameraNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: 0) // rotation - Quarternion 카메라 회전

        // 4: Set camera on scene
        scene?.rootNode.addChildNode(cameraNode)
//        scene?.rootNode.addChildNode(node)

        // 5: Adding light to scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 35)
        scene?.rootNode.addChildNode(lightNode)

        // 6: Creating and adding ambien light to scene
//        let ambientLightNode = SCNNode()
//        ambientLightNode.light = SCNLight()
//        ambientLightNode.light?.type = .ambient
//        ambientLightNode.light?.color = UIColor.darkGray
//        scene?.rootNode.addChildNode(ambientLightNode)

        // If you don't want to fix manually the lights
        sceneView.autoenablesDefaultLighting = true

        // Allow user to manipulate camera
        sceneView.allowsCameraControl = true

        // Show FPS logs and timming
        // sceneView.showsStatistics = true

        // Set background color
        sceneView.backgroundColor = UIColor.black

        // Allow user translate image
        sceneView.cameraControlConfiguration.allowsTranslation = false
//        sceneView.debugOptions = [.showWireframe, .showBoundingBoxes]
        // Set scene settings
        sceneView.scene = scene
    }
}
