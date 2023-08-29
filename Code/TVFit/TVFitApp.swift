//
//  TVFitApp.swift
//  TVFit
//
//  Created by Simon Lam on 2021-03-27.
//

import SwiftUI

@main
struct TVFitApp: App {
    
    @StateObject var settings = Settings()
    var body: some Scene {
        WindowGroup {
            Controller()
                .environmentObject(settings)
//            MenuView()
//                .environmentObject(settings)
        }
    }
}
