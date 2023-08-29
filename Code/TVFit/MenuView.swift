//
//  ContentView.swift
//  TVFit
//
//  Created by Simon Lam on 2021-03-27.
//


// Things to do:
// - extend welcome back background into the safe area without shifting the label

// Extra things:
// - possibly add new animations transitioning between pages

import SwiftUI
import ARKit
import RealityKit

struct MenuView: View {
    
    @Binding var mode: String
    @Binding var controllerScreen: Int
    @Binding var selections: Int
    @Binding var version: String
    var topOff: CGFloat
    var botOff: CGFloat
    
    @EnvironmentObject var settings: Settings
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        // overall screen vert
        
        VStack {
            // MARK: - Top Bar
            MenuTopBarView(t: "Welcome to TVFit!",
                           d: "To get started, please choose an option",
                           off: topOff)
            
            Spacer()
            
            // MARK: - Main Buttons
            HStack {
                Spacer()
                
                // auto button
                Button(
                    action: {
                        withAnimation {
                            mode = "A"
                            settings.forward = true
                            selections = 0
                        }
                    },
                    label: {
                        MenuButtonLabel(mainText: "Automatic",
                                        description: "We will recommend TV sizes for you based on your space.",
                                        w: screenSize.width * 0.8 / 2,
                                        h: screenSize.height * 0.4,
                                        imageName: "MenuAuto")
                    })
                
                Spacer()
                
                Button(
                    action: {
                        withAnimation {
                            mode = "M"
                            settings.forward = true
                            selections = -1
                        }
                    },
                    label: {
                        MenuButtonLabel(mainText: "Manual",
                                        description: "We will let you manually input any of our preset TV sizes to your space.",
                                        w: screenSize.width * 0.8 / 2,
                                        h: screenSize.height * 0.4,
                                        imageName: "MenuManual")
                    })
                Spacer()
            }
            
            Spacer()
            
            Text(version)
                .font(.custom("Roboto", size: 10))
                .foregroundColor(Color.gray.opacity(0.7))
                .padding(5)
                .offset(x: 0, y: -botOff)
        }
        .navigationBarTitle("Menu")
        .navigationBarHidden(true)
        .background(Color("BackgroundColour"))
        .ignoresSafeArea()
    }
}



struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        Spacer()
        //MenuView()
    }
}
