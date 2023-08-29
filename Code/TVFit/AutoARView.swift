//
//  ARScreen.swift
//  TVFit
//
//  Created by Simon Lam on 2021-03-29.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct AutoARView: View {
    @Binding var mode: String
    @Binding var controllerScreen: Int
    @Binding var selections: Int
    @Binding var distance: Double
    @Binding var showShare: Bool
    @Binding var onPlane: Bool
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
                // MARK: - Top Bar
                let titles = ["Confirm Your Distance", "Recommendations", "Download and Share"]
                let descriptions = ["Sit at your ideal distance away from the TV. Please allow the box to turn solid", "TV Size: " + recommendation, "Download your creation and share via your social media."]
                ARTopBarView(t: titles[step], d: descriptions[step], step: step, off: topOff)
                
                // MARK: - Back Button
                HStack {
                    // back to main menu
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
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            })
                    }
                    // else back one screen
                    else {
                        Button(
                            action: {
                                if (step == 1) {
                                    settings.distance = 0
                                    distance = 0
                                    settings.reset = true
                                }
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
                    }
                    Spacer()
                    // MARK: - Clear Button
                    if (step != 0) {
                        Button(
                            action: {
                                selections = -2
                                settings.clearEntity = true
                            }, label: {
                                Text("Clear")
                                    .font(.custom("Roboto", size: 16))
                                    .padding(11)
                                    .background(Color("AccentColour"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            })
                            
                    }
                }
                .padding(15)
                
                // MARK: - Distance
                
                ZStack {
                    VStack {
                        Spacer()
                        
                        if (distance != 0 && step == 0 && !settings.coachingActive) {
                            VStack (spacing: 0) {
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: 4)
                                    .foregroundColor(Color.red.opacity(0))
                                    .frame(width: 25, height: 25)
                                Line()
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                    .fill(Color.white)
                                    .frame(maxWidth: 1, maxHeight: ((screenSize.height - screenSize.height * 0.06 - screenSize.height * 0.14 - 25 - 45 - topOff - botOff) / 4))
                                Text(String(distance) + "m")
                                    .font(.custom("Roboto", size: 16))
                                    .padding(10)
                                    .foregroundColor(Color("TextColour"))
                                    .background(Color.white)
                                    .cornerRadius(10)
                                Line()
                                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                                    .fill(Color.white)
                                    .frame(maxWidth: 1, maxHeight: ((screenSize.height - screenSize.height * 0.06 - screenSize.height * 0.14 - 25 - 45 - topOff - botOff) / 4))
                            }
                        }
                    }
                }
                
                
                // MARK: - Bottom Elements
                if (step == 0) {
                    VStack {
                        Button(action: {
                            if (distance != 0 && onPlane == true) {
                                withAnimation {
                                    step += 1
                                }
                                let inches = (distance * 39.37) / 2
                                print("recommend tv's around \(inches) inches")
                                selections = settings.numbers.count - 1
                                for i in 0..<settings.numbers.count {
                                    if (inches <= Double(settings.numbers[i])) {
                                        selections = i
                                        break
                                    }
                                }
                            }
                        }, label: {
                            VStack {
                                Text("Confirm")
                                    .font(.custom("Roboto", size: 16))
                                    .frame(width: screenSize.width * 0.8, height:  screenSize.height * 0.06 * 0.9)
                                    .background(Color((distance != 0 && onPlane) ? "AccentColour" : "Gray"))
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
                           maxHeight: screenSize.height * 0.06 * 0.9 + 20 * 2 + botOff)
                    .background(Color.white)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
                
                else if (step == 1) {
                    
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

struct AutoARView_Previews: PreviewProvider {
    static var previews: some View {
        Spacer()
        //AutoARView(topOff: 44, botOff: 0)
    }
}
