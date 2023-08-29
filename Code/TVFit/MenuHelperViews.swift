//
//  MenuHelperViews.swift
//  TVFit
//
//  Created by Anders Tai on 2021-04-09.
//

import SwiftUI

struct MenuHelperViews: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - MenuTopBar
struct MenuTopBarView: View {
    var t: String
    var d: String
    var off: CGFloat
    let screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        let fontSize = screenSize.height * 0.135 * 0.2
        let fontSizeDes = screenSize.height * 0.135 * 0.15 - 2
        let paddingValue: CGFloat = 18.0

        ZStack {
            Color
                .white
                .frame(maxWidth: .infinity,
                       maxHeight: screenSize.height * 0.135 + off)
                .shadow(radius: 5, y: 10)
            VStack (alignment: .leading) {
                Text(t)
                    .font(.custom("Roboto", size: fontSize))
                    .foregroundColor(Color("TextColour"))
                    .padding([.leading, .top], paddingValue)
                    .offset(x: 0, y: off / 2)
                Text(d)
                    .font(.custom("Roboto", size: fontSizeDes))
                    .foregroundColor(Color("TextColour"))
                    .padding([.leading, .trailing], paddingValue)
                    .padding(.top, 1)
                    .offset(x: 0, y: off / 2)
                Spacer()
            }
            .frame(maxWidth: .infinity,
                   maxHeight: screenSize.height * 0.135,
                   alignment: .leading)
        }
    }
}

// MARK: - MenuButtons
struct MenuButtonLabel: View {
    var mainText: String
    var description: String
    var w: CGFloat
    var h: CGFloat
    var imageName: String
    let screenSize: CGRect = UIScreen.main.bounds
    
    var body: some View {
        let fontSize = screenSize.height * 0.135 * 0.2
        let fontSizeDes = h * 0.25 * 0.175
        
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(maxWidth: w,
                       maxHeight: h)
                .shadow(radius: 5, x: 10, y: 10)
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("AccentColour"))
                .frame(maxWidth: w,
                       maxHeight: h)
                .clipShape(Rectangle().offset(x: 0, y: h * 0.7))
            
            VStack (alignment: .leading){
                Text(String(mainText))
                    .font(.custom("Roboto", size: fontSize))
                    .fontWeight(.bold)
                    .foregroundColor(Color("AccentColour"))
                    .padding([.top, .leading], w / 10)
                Spacer()
                HStack {
                    Spacer()
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: w * 0.9,
                               maxHeight: h * 0.5)
                    Spacer()
                }
                Spacer()
                Text(description)
                    .font(.custom("Roboto", size: fontSizeDes))
                    .foregroundColor(.white)
                    .frame(maxWidth: w,
                           maxHeight: h * 0.3 - 2 * 10,
                           alignment: .topLeading)
                    .padding(10)
                
            }
            .frame(maxWidth: w,
                   maxHeight: h)
        }
        .frame(maxWidth: w,
               maxHeight: h)
    }
}

struct MenuHelperViews_Previews: PreviewProvider {
    static var previews: some View {
        MenuHelperViews()
    }
}
