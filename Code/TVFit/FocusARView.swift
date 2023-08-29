//
//  FocusARView.swift
//  TVFit
//
//  Created by Simon Lam on 2021-04-02.
//

import SwiftUI
import ARKit
import RealityKit
import FocusEntity

class FocusARView: ARView {
    var focusEntity: FocusEntity?
    //var focusDelegate: FocusEntityDelegate?
    //var coachingDelegate: ARCoachingOverlayViewDelegate?
    var coachingActive = true
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        //focusEntity = FocusEntity(on: self, focus: .classic)
        
        do {
          let onColor: MaterialColorParameter = try .texture(.load(named: "Close"))
          let offColor: MaterialColorParameter = try .texture(.load(named: "Open"))
          self.focusEntity = FocusEntity(
            on: self,
            style: .colored(
              onColor: onColor, offColor: offColor,
              nonTrackingColor: offColor
            )
          )
        } catch {
          self.focusEntity = FocusEntity(on: self, focus: .classic)
          print("Unable to load plane textures")
          print(error.localizedDescription)
        }
        
        configure()
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic

        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) {
            config.sceneReconstruction = .meshWithClassification
        }
        print("session running")
        session.run(config, options: [.resetTracking, .removeExistingAnchors])
    }
    
}
