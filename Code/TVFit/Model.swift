//
//  Model.swift
//  TVFit
//
//  Created by Simon Lam on 2021-03-31.
//

import SwiftUI
import RealityKit
import Combine

class Model {
    var name: String
    var vertEntity: ModelEntity?
    var horEntity: ModelEntity?
    
    private var c: AnyCancellable?
    private var cc: AnyCancellable?

    
    init(name: String) {
        self.name = name
        asyncLoadModel()
    }
    
    func asyncLoadModel() {
        let filename = "WM" + self.name + ".usdz"
        
        self.c = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { (loadCompletion) in
                switch loadCompletion {
                case .failure(let error):
                    print("Unable to load model \(filename)")
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    print("loaded model: \(filename)")
                    break
                }
            }, receiveValue: { (modelEntity) in
                self.vertEntity = modelEntity
            })
        
        let fn = "TS" + self.name + ".usdz"
        
        self.cc = ModelEntity.loadModelAsync(named: fn)
            .sink(receiveCompletion: { (loadCompletion) in
                switch loadCompletion {
                case .failure(let error):
                    print("Unable to load model \(fn)")
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    print("loaded model: \(fn)")
                    break
                }
            }, receiveValue: { (modelEntity) in
                self.horEntity = modelEntity
            })
    }
}
