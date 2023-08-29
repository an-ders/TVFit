//
//  Controller.swift
//  TVFit
//
//  Created by Anders Tai on 2021-04-09.
//

import SwiftUI

struct Controller: View {
    
    @EnvironmentObject var settings: Settings

    @State var mode: String = "H"
    @State var screen = 0
    @State var selections = 0
    @State var distance: Double = 0
    @State var showShare: Bool = false
    @State var onPlane = false
    @State var version = "v1.0"

    var body: some View {
        GeometryReader { geometry in
            let topOff = geometry.safeAreaInsets.top
            let botOff = geometry.safeAreaInsets.bottom / 2
            
            ZStack {
                // MARK: - ArView
                ARViewContainer(distance: $distance, showShare: $showShare, onPlane: $onPlane)
                    .zIndex(0)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        settings.pause = true
                    }
                
                // Add a blocker for the ar view when transitioning
                if (screen != 1) {
                    Color("BackgroundColour")
                        .zIndex(1)
                }
                
                // MARK: - Auto Mode
                if (mode == "A") {
                    if (screen == 0) {
                        AutoTutorialView(mode: $mode, controllerScreen: $screen, topOff: topOff, botOff: botOff)
                            .transition(.asymmetric(insertion: .move(edge: settings.forward ? .trailing : .leading), removal: .move(edge: settings.forward ? .leading : .trailing)))
                            .zIndex(3)
                    } else {
                        AutoARView(mode: $mode, controllerScreen: $screen, selections: $selections, distance: $distance, showShare: $showShare, onPlane: $onPlane, topOff: topOff, botOff: botOff)
                            .transition(.asymmetric(insertion: .move(edge: settings.forward ? .trailing : .leading), removal: .move(edge: settings.forward ? .leading : .trailing)))
                            .zIndex(4)
                    }
                }
                
                // MARK: - Manual Mode
                else if (mode == "M") {
                    if (screen == 0) {
                        ManualTutorialView(mode: $mode, controllerScreen: $screen, topOff: topOff, botOff: botOff)
                            .transition(.asymmetric(insertion: .move(edge: settings.forward ? .trailing : .leading), removal: .move(edge: settings.forward ? .leading : .trailing)))
                            .zIndex(5)

                    } else {
                        ManualARView(mode: $mode, controllerScreen: $screen, selections: $selections, distance: $distance, showShare: $showShare, topOff: topOff, botOff: botOff)
                            .transition(.asymmetric(insertion: .move(edge: settings.forward ? .trailing : .leading), removal: .move(edge: settings.forward ? .leading : .trailing)))
                            .zIndex(6)
                    }
                }
                
                // MARK: - Main Menu
                else {
                    MenuView(mode: $mode, controllerScreen: $screen, selections: $selections, version: $version, topOff: topOff, botOff: botOff)
                        .transition(.asymmetric(insertion: .move(edge: settings.forward ? .trailing : .leading), removal: .move(edge: settings.forward ? .leading : .trailing)))
                        .zIndex(2)

                }
            }
            
        }
        
    }
}

struct Controller_Previews: PreviewProvider {
    static var previews: some View {
        Controller()
    }
}
