//Created by me on 24/10/20

import Foundation
import RealityKit
import FocusEntity
import Combine
import ARKit
import UIKit

class FocusARView: ARView {
  var focusEntity: FocusEntity?
  required init(frame frameRect: CGRect) {
    super.init(frame: frameRect)
    self.setupConfig()
    self.focusEntity = FocusEntity(on: self, style: .classic)
  }

//  func setupConfig() {
//    let config = ARWorldTrackingConfiguration()
//    config.planeDetection = [.horizontal, .vertical]
//    session.run(config, options: [])
//  }
    func setupConfig() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection=[.horizontal,.vertical]
        config.environmentTexturing = .automatic
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        session.run(config)
    }

  @objc required dynamic init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension FocusARView: FocusEntityDelegate {
  func toTrackingState() {
    print("tracking")
  }
  func toInitializingState() {
    print("initializing")
  }
}
