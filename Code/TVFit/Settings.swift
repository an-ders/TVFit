//
//  PlacementSettings.swift
//  TVFit
//
//  Created by Simon Lam on 2021-03-31.
//

import SwiftUI
import ARKit
import RealityKit
import Combine

class Settings: ObservableObject  {
    
    // model adding variables
    var currentModel: Model?
    var addModel: Model?
    var clearEntity: Bool = false
    var reset: Bool = false
    var pause: Bool = false
    var sceneObserver: Cancellable?
    
    // model loadinhg and names
    let numbers = [32, 40, 43, 50, 55, 60, 65, 70, 80]
    
    let linksCA = ["https://amzn.to/2Qzxl90",
                   "https://amzn.to/3v7C7JF",
                   "https://amzn.to/3gtkP5N",
                   "https://amzn.to/2P65ZqI",
                   "https://amzn.to/3tAJQj4",
                   "https://amzn.to/3x8bhDg",
                   "https://amzn.to/32uDbeI",
                   "https://amzn.to/3ssfRbS"]
    
    let linksUS = ["https://amzn.to/32tyfqb",
                   "https://amzn.to/3v6ESv8",
                   "https://amzn.to/3gp528c",
                   "https://amzn.to/2RK0yP3",
                   "https://amzn.to/3tA9lBl",
                   "https://amzn.to/3uYHaMs",
                   "https://amzn.to/3tAtQO3",
                   "https://amzn.to/3x7ntEj"]

    var models: [String:Model] = [:]
    
    // controller direction
    var forward = true
    
    var coachingActive = false
    
    // distance
    var getDistance = false
    var distance: Double = 0
    
    // ss and share
    var screenshot = false
    var share = false
    var image: UIImage?
    
    var onPlane = false
    
    var firstLoad = false
}
