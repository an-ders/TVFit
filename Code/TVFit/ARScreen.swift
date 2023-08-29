//
//  ARScreen.swift
//  TVFit
//
//  Created by Simon Lam on 2021-04-08.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARScreen: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - Container
struct ARViewContainer: UIViewRepresentable {
    
    @Binding var distance: Double
    @Binding var showShare: Bool
    @Binding var onPlane: Bool
    
    @EnvironmentObject var settings: Settings
    
    func makeUIView(context: Context) -> FocusARView {
        let arView = FocusARView(frame: .zero)
        
        arView.addCoaching()
        
        self.settings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            self.updateScene(for: arView)
        })
        
        return arView
    }

    func updateUIView(_ uiView: FocusARView, context: Context) {}
    
    // MARK: - UPDATE
    private func updateScene(for arView: FocusARView) {
        
        arView.focusEntity?.isEnabled = (self.settings.currentModel == nil && !arView.coachingActive)
        
        withAnimation {
            onPlane = arView.focusEntity?.onPlane == true
        }
        
        self.settings.coachingActive = arView.coachingActive == true
        
        // MARK: - Share
        if (self.settings.share) {
            arView.snapshot(saveToHDR: false) { image in
                settings.image = image
            }
            showShare = true
            self.settings.share = false
        }
        
        // MARK: - Screenshot
        if (self.settings.screenshot) {
            arView.snapshot(saveToHDR: false) { image in
                let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: image!)
            }
            self.settings.screenshot = false
        }
        
        // MARK: - Distance
        //if (self.settings.getDistance) {
            if let v1 = arView.focusEntity?.position, let v2 = arView.focusEntity?.currentPlaneAnchor?.center {
                let product: SIMD3<Float> = [v1.x + v2.x, v1.y + v2.y, v1.z + v2.z]
                //let product: SIMD3<Float> = [v1.x, v1.y, v1.z]
                
                let translate = arView.cameraTransform.translation
                
                let x = translate.x - product.x
                let y = translate.y - product.y
                let z = translate.z - product.z
                
                distance = sqrt(Double(x * x + y * y + z * z))
                distance = round(distance * 100) / 100
                settings.distance = distance
                //self.settings.getDistance = false
            }
        //}
        
        // MARK: - Reset
        if (self.settings.reset) {
            print("reset")
            arView.configure()
            self.settings.clearEntity = true
            distance = 0
            settings.distance = 0
            self.settings.firstLoad = false
            self.settings.reset = false
        }
        
        // MARK: - Clearing Model
        if (self.settings.clearEntity){
            if let model = self.settings.currentModel {
                if let vertEntity = model.vertEntity {
                    vertEntity.removeFromParent()
                }
                if let horEntity = model.horEntity {
                    horEntity.removeFromParent()
                }
                self.settings.currentModel = nil
            }
            self.settings.clearEntity = false
        }
        
        // MARK: - Pause
        if (self.settings.pause) {
            print("pausing")
            arView.session.pause()
            self.settings.pause = false
        }
        
        // MARK: - Adding Model
        if let confirmedModel = self.settings.addModel {
            
            let alignment = arView.focusEntity?.currentPlaneAnchor?.alignment
            
            if (alignment == .vertical) {
                if let vertEntity = confirmedModel.vertEntity {
                    vertEntity.generateCollisionShapes(recursive: true)
                    arView.installGestures([.translation], for: vertEntity)
                    let v = AnchorEntity(plane: .vertical)
                    v.addChild(vertEntity)
                    arView.scene.addAnchor(v)
                    self.settings.currentModel = self.settings.addModel
                    self.settings.addModel = nil
                }
            }
            else if (alignment == .horizontal) {
                if let horEntity = confirmedModel.horEntity {
                    horEntity.generateCollisionShapes(recursive: true)
                    arView.installGestures([.translation], for: horEntity)
                    let h = AnchorEntity(plane: .horizontal)
                    h.addChild(horEntity)
                    arView.scene.addAnchor(h)
                    self.settings.currentModel = self.settings.addModel
                    self.settings.addModel = nil
                }
            }
        }
    }
}

// MARK: - Coaching
extension FocusARView: ARCoachingOverlayViewDelegate {
    
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.setActive(true, animated: true)
        coachingOverlay.goal = .anyPlane
        self.addSubview(coachingOverlay)
    }
    
    public func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("coaching enabled")
        self.coachingActive = true
    }
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("coaching disabled")
        self.coachingActive = false
    }
}

// MARK: - Image Saver
class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}


struct ARScreen_Previews: PreviewProvider {
    static var previews: some View {
        ARScreen()
    }
}
