//
//  ManualARView.swift
//  TVFit
//
//  Created by Simon Lam on 2021-04-08.
//

import SwiftUI

struct ManualARView: View {
    @Binding var mode: String
    @Binding var controllerScreen: Int
    @Binding var selections: Int
    @Binding var distance: Double
    @Binding var showShare: Bool
    var topOff: CGFloat
    var botOff: CGFloat
    
    
    @EnvironmentObject var settings: Settings
    @Environment(\.openURL) var openURL

    @State var step = 0
    @State var recommendation = ""
    
    var body: some View {
        let screenSize: CGRect = UIScreen.main.bounds
        
        ZStack {
            
            VStack (spacing: 0) {
                
                // MARK: - Back Button
                HStack {
                    if (step == 0) {
                        Button(
                            action: {
                                withAnimation {
                                    controllerScreen = 0
                                }
                                settings.pause = true
                                settings.forward = false
                            },
                            label: {
                                Text("Back")
                                    .font(.custom("Roboto", size: 16))
                                    .padding(11)
                                    .background(Color("AccentColour"))
                                    . foregroundColor(.white)
                                    .cornerRadius(20)
                            })
                            .padding(20)
                            
                    } else {
                        Button(
                            action: {
                                withAnimation {
                                    step -= 1;
                                }
                            }, label: {
                                Text("Back")
                                    .font(.custom("Roboto", size: 16))
                                    .padding(11)
                                    .background(Color("AccentColour"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            })
                            .padding(20)
                    }
                    Spacer()
                    // MARK: - Clear Button
                    Button(
                        action: {
                            settings.clearEntity = true
                            selections = -1
                        }, label: {
                            Text("Clear")
                                .font(.custom("Roboto", size: 16))
                                .padding(11)
                                .background(Color("AccentColour"))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        })
                        .padding(20)
                }
                .offset(x: 0, y: topOff)
                
                Spacer()
                
                // MARK: - Bottom Elements
                if (step == 0) {
                    DownloadShareDonate(mode: $mode, controllerScreen: $controllerScreen, showShare: $showShare, botOff: botOff)
                    
                    ARTVOptionsView(selections: $selections, recommendation: $recommendation)
                    
                    VStack {
                        Button(action: {
                            if (selections > -1) {
                                openURL(URL(string: (Locale.current.regionCode == "CA") ? settings.linksCA[selections] : settings.linksUS[selections])!)
                            }
                        }, label: {
                            VStack {
                                Text("SHOP ON AMAZON")
                                    .font(.custom("Roboto", size: 16))
                                    .frame(width: screenSize.width * 0.8, height:  screenSize.height * 0.06 * 0.9)
                                    .background(Color((selections > -1) ? "AccentColour" : "Gray"))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(20)
                                if (botOff > 0) {
                                    Spacer()
                                }
                            }
                    })
                    }
                    .frame(maxWidth: .infinity,
                           maxHeight: screenSize.height * 0.06 * 0.8 + 20 * 2 + botOff)
                    .background(Color.white)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            
            }
        }
        .ignoresSafeArea()
    }
}

struct ManualARView_Previews: PreviewProvider {
    static var previews: some View {
        Spacer()
        //ManualARView()
    }
}
