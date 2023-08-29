//
//  ARHelperViews.swift
//  TVFit
//
//  Created by Simon Lam on 2021-04-08.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARHelperViews: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - Top Bar
struct ARTopBarView: View {
    var t: String
    var d: String
    var step: Int
    var off: CGFloat
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        let fontSize = screenSize.height * 0.135 * 0.2
        //let fontSizeDes = screenSize.height * 0.135 * 0.15 - 2
        let fontSizeDes: CGFloat = 13
        let paddingValue: CGFloat = 18.0

        ZStack {
            Color
                .white
                .frame(maxWidth: .infinity,
                       maxHeight: screenSize.height * 0.135 + off)
                .shadow(radius: 5, y: 10)
            HStack (spacing: 0) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 10)
                        .foregroundColor(Color.gray)
                        .frame(maxWidth: screenSize.height * 0.08,
                               maxHeight: screenSize.height * 0.08)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(step + 1) / 2.0)
                        .stroke(lineWidth: 10)
                        .foregroundColor(Color("AccentColour"))
                        .rotationEffect(.degrees(-90.0))
                        .frame(maxWidth: screenSize.height * 0.08,
                               maxHeight: screenSize.height * 0.08)
                    
                    VStack {
                        Spacer()
                        Text("\(step + 1)/2")
                            .font(.custom("Roboto", size: fontSizeDes))
                            .foregroundColor(Color("TextColour"))
                        Spacer()
                    }
                    .frame(maxWidth: screenSize.height * 0.08,
                           maxHeight: screenSize.height * 0.08)
                }
                .padding(paddingValue)
                .offset(x: 0, y: off / 2)
                
                VStack (alignment: .leading,
                        spacing: fontSize / 3) {
                    Text(t)
                        .font(.custom("Roboto", size: fontSize))
                        .foregroundColor(Color("TextColour"))
                        .padding([.top], paddingValue)
                        .offset(x: 0, y: off / 2)
                    Text(d)
                        .font(.system(size: (d[d.index(d.startIndex, offsetBy: 7)] == ":") ? 20 : fontSizeDes))
                        .foregroundColor(Color("TextColour"))
                        .padding([.trailing], paddingValue)
                        .offset(x: 0, y: off / 2)
                    Spacer()
                }
                .frame(maxWidth: .infinity,
                       maxHeight: screenSize.height * 0.135,
                       alignment: .leading)
                Spacer()
            }
        }
    }
}

// MARK: - Options Menu
struct ARTVOptionsView: View {
    @EnvironmentObject var settings: Settings
    @Binding var selections: Int
    @State var hidden: Bool = false
    @State var modelPicker = 0
    @Binding var recommendation: String
    
    var body: some View {
        //let screenSize: CGRect = UIScreen.main.bounds
        
        VStack (alignment: .leading) {
            // top bar
            HStack {
                Text("TV SELECTONS")
                    .font(.custom("Roboto", size: 15))
                    .padding([.top, .leading, .trailing], 15)
                Spacer()
                // hide and unhide button
                Button(
                    action: {
                        withAnimation {
                            hidden.toggle()
                        }
                    }, label: {
                        Image(systemName: (hidden) ? "chevron.up" : "chevron.down")
                            .foregroundColor(Color("AccentColour"))
                            .padding(15)
                            .transition(.move(edge: .bottom))
                    })

            }
            
            if (!hidden) {
                VStack {
                    Options(selections: $selections)
                }
                .transition(.move(edge: .bottom))
            }
        }
        .background(Color.white)
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        .onAppear {
            // MARK: Options Menu - Selection
            if (selections != -1 && !settings.firstLoad) {
                let inches = (settings.distance * 39.37) / 2
                var name = self.settings.numbers[settings.numbers.count - 1]
                for i in 0..<settings.numbers.count {
                    if (inches <= Double(settings.numbers[i])) {
                        name = settings.numbers[i]
                        selections = i
                        break
                    }
                }
                recommendation = String(self.settings.numbers[selections])
                self.settings.clearEntity = true
                settings.firstLoad = true
                
                // not storing already loaded models
                let model = Model(name: String(name))
                self.settings.addModel = model
                
                // storing already loaded models
//                if (self.settings.models[name] == nil) {
//                    self.settings.models[name] = Model(name: name)
//                }
//                self.settings.addModel = self.settings.models[name]
//
                
                
            }
        }
    }
}

// MARK: - Options Bar
struct Options: View {
    @EnvironmentObject var settings: Settings

    @Binding var selections: Int
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 20) {
                ForEach(0..<settings.numbers.count) { i in
                    Button(action: {
                        // MARK: Options Bar - Selections
                        if (selections != i) {
                            selections = i
                            
                            let name = self.settings.numbers[selections]
                            self.settings.clearEntity = true

                            // not storing already loaded models
                            let model = Model(name: String(name))
                            self.settings.addModel = model
                            
                            // not storing already loaded models
//                            if (self.settings.models[name] == nil) {
//                                self.settings.models[name] = Model(name: name)
//                            }
//                            self.settings.addModel = self.settings.models[name]
//
                        }
                    }, label: {
                        Text(String(settings.numbers[i]) + "\"")
                            .font(.custom("Roboto", size: 20))
                            .padding(10)
                            .background(Color((selections == i) ? "AccentColour" : "BackgroundColour"))
                            .cornerRadius(10)
                            .foregroundColor((selections == i) ? .white : Color("TextColour"))
                    })
                }
            }
            .padding([.leading, .trailing], 30)
            .padding(.bottom, 15)
        }
    }
}

struct Separator: View {
    var body: some View {
        Divider()
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
    }
}

// MARK: - Bottom Button
struct ARBottomButtonView: View {
    var text: String
    var botOff: CGFloat
    var action: () -> Void
    
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        let screenSize: CGRect = UIScreen.main.bounds
        VStack {
            Button(action: {
                action()
            }, label: {
                VStack {
                    Text(text)
                        .font(.custom("Roboto", size: 16))
                        .frame(width: screenSize.width * 0.8, height:  screenSize.height * 0.06 * 0.9)
                        .background(Color("AccentColour"))
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



// MARK: - Icons
struct Icon: View {
    var imageName: String
    var description: String
    
    var body: some View {
        
        VStack {
            Image(systemName: imageName)
                .resizable()
                .frame(maxWidth: 25, maxHeight: 25)
            Text(description)
                .font(.custom("Roboto", size: 10))
        }
        .padding([.leading, .trailing], 15)
        .foregroundColor(Color.white)
    }
}

// MARK: - DownloadShareDonate
struct DownloadShareDonate: View {
    @Binding var mode: String
    @Binding var controllerScreen: Int
    @Binding var showShare: Bool
    var botOff: CGFloat
    
    @EnvironmentObject var settings: Settings
    @State var showAlert = false
    
    @Environment(\.openURL) var openURL
    var body: some View {
        HStack (spacing: 10){
            // screenshot
            Button(
                action: {
                    settings.screenshot = true
                    showAlert = true
                },
                label: {
                    Icon(imageName: "arrow.down.to.line.alt",
                         description: "Download")
                })
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Image Saved"))
                }
            // share
            Button(
                action: {
                    settings.share = true
                    //showShare = true
                },
                label: {
                    Icon(imageName: "arrow.up.to.line.alt",
                         description: "Share")
                })
                .sheet(isPresented: $showShare) {
                    if let image = settings.image {
                        ShareSheet(activityItems: [image])
                    }
                }
            // donate
            Button(action: {
                openURL(URL(string: "https://www.paypal.com/paypalme/baboo2")!)
            }, label: {
                Icon(imageName: "smiley",
                            description: "Donate")
            })
            
            Spacer()
            // home
            Button(
                action: {
                    settings.pause = true
                    settings.forward = false
                    settings.reset = true
                    withAnimation {
                        mode = "H"
                        controllerScreen = 0
                    }
                },
                label: {
                    Text("Go Back Home")
                        .font(.custom("Roboto", size: 12))
                        .padding(11)
                        .background(Color("AccentColour"))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                })
                .padding(.trailing, 10)
        }
        .padding(15)
        .offset(x: 0, y: -(botOff))
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
}

// MARK: - Share Menu
struct ShareSheet: UIViewControllerRepresentable {
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

// MARK: - Dotted Line
struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        return path
    }
}

struct ARHelperViews_Previews: PreviewProvider {
    static var previews: some View {
        ARHelperViews()
    }
}
