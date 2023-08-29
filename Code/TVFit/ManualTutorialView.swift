//
//  ManualTutorialView.swift
//  TVFit
//
//  Created by Simon Lam on 2021-04-08.
//

import SwiftUI
import ARKit
import RealityKit
import UIKit

struct ManualTutorialView: View {
    @Binding var mode: String
    @Binding var controllerScreen: Int
    var topOff: CGFloat
    var botOff: CGFloat
    
    @EnvironmentObject var settings: Settings

    @State private var screen = 0
    @State var forward: Bool = true
    let screensCount = 2

    var title  = "Tutorial for Manual AR"
    var descriptions = ["Sit on your couch, or your desired sitting distance from your TV. Please Allow the box to turn solid.", "Once you’re satisfied, you can download and share this screenshot. Donate if you like our app!"]
    
    var body: some View {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let descriptionsLen = 1
        
        VStack {
            // MARK: - Top Elements
            TopBarWrapper(s: $screen, title: title, description: descriptions, offset: topOff)
                .transition(.move(edge: .leading))
            HStack {
                Button(
                    action: {
                        withAnimation {
                            settings.forward = false
                            settings.pause = true
                            mode = "H"
                            controllerScreen = 0
                        }
                    }, label: {
                        Text("Back to Menu")
                            .font(.custom("Roboto", size: 16))
                            .foregroundColor(Color("AccentColour"))
                    })
                
                Spacer()

                Button(
                    action: {
                        withAnimation {
                            controllerScreen = 1
                            settings.forward = true
                            settings.reset = true
                        }
                    }, label: {
                        HStack {
                                Text("Skip")
                                    .font(.custom("Roboto", size: 16))
                                    .foregroundColor(Color("AccentColour"))
                            Image(systemName: "chevron.right.2")
                                .foregroundColor(Color("AccentColour"))
                        }
                    })
            }
            .padding()
            Spacer()
            // MARK: - Animations
            VStack {
                switch screen {

                case 1:
                    Animation(name: "ManualAnimation", num: screen)
                        .transition(.asymmetric(insertion: .move(edge: (forward) ? .trailing : .leading), removal: .move(edge: (forward) ? .leading : .trailing)))

                default:
                    Animation(name: "ManualAnimation", num: screen)
                        .transition(.asymmetric(insertion: .move(edge: (forward) ? .trailing : .leading), removal: .move(edge: (forward) ? .leading : .trailing)))

                }
            }
            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
                        .onEnded({ value in
                            if (value.translation.width < 0) {
                                // left
                                //print("left")
                                withAnimation {
                                    if (screen < descriptionsLen - 1) {
                                        forward = true
                                        screen += 1
                                    }
                                }
                            }
                            
                            if (value.translation.width > 0) {
                                // right
                                //print("right")
                                withAnimation {
                                    if (screen > 0) {
                                        forward = false
                                        screen -= 1
                                    }
                                }
                            }
                        }))
            
            Spacer()
            
            // MARK: - Bottom Bar - Last
            if (screen == descriptionsLen - 1) {
                VStack (spacing: 0) {
                    
                    Button(
                        action: {
                            withAnimation {
                                controllerScreen = 1
                            }
                            settings.forward = true
                            settings.reset = true
                        },
                        label: {
                            Text("START")
                                .font(.custom("Roboto", size: 16))
                                .frame(width: screenSize.width * 0.8, height:  screenSize.height * 0.05)
                                .background(Color("AccentColour"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(15)
                        })
                    
                    Button(action: {
                        withAnimation {
                            forward = false
                            screen = 0
                        }
                    }, label: {
                        VStack {
                            Text("REPEAT TUTORIAL")
                                .font(.custom("Roboto", size: 16))
                                .frame(width: screenSize.width * 0.8, height:  screenSize.height * 0.05)
                                .background(Color("Gray"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        })
                    Spacer()
                }
                .frame(maxWidth: screenSize.width, maxHeight: screenSize.height * 0.10 + 15 * 3 + botOff)
                .background(Color.white)
                .transition(.move(edge: .trailing))
            }
            // MARK: Bottom Bar - Rest
            else {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            if (screen > 0) {
                                forward = false
                                screen -= 1
                            }
                        }
                    }, label: {
                        Text("Back")
                            .font(.custom("Roboto", size: 16))
                            .padding(10)
                            .foregroundColor(Color((screen == 0) ? "BackgroundColour" : "AccentColour"))
                    })
                    Spacer()
                    HStack {
                        ForEach(0 ..< descriptionsLen) { i in
                            Dot(id: i, s: $screen)
                        }
                    }
                    Spacer()
                    Button(action: {
                        withAnimation {
                            if (screen < descriptionsLen - 1) {
                                forward = true
                                screen += 1
                            }
                        }
                    }, label: {
                        Text("Next")
                            .font(.custom("Roboto", size: 16))
                            .padding(10)
                            .foregroundColor(Color("AccentColour"))
                    })
                    Spacer()
                }
                .padding(20)
                .offset(x: 0, y: -botOff)
            }
        }
        .background(Color("BackgroundColour"))
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

struct ManualTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        Spacer()
        //ManualTutorialView()
    }
}
