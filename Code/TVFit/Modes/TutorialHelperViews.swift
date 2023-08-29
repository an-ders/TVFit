//
//  TutorialHelperViews.swift
//  TVFit
//
//  Created by Simon Lam on 2021-04-08.
//

import SwiftUI

struct TutorialHelperViews: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - Dot
struct Dot: View {
    var id: Int
    @Binding var s: Int
    
    var body: some View {
        let c = (s == id) ? Color("AccentColour") : Color.gray
        
        Circle()
            .fill(c)
            .frame(width: 20, height: 20)
    }
}

// MARK: - Top Bar
struct TopBarWrapper: View {
    @Binding var s: Int
    var title: String
    var description: [String]
    var offset: CGFloat
    
    var body: some View {
        MenuTopBarView(t: title, d: description[s], off: offset)
            .transition(.move(edge: .leading))
    }
}

// MARK: - Animations
func animatedImages (for name: String) -> [UIImage] {
    var i = 0;
    var images = [UIImage]()
    
    while let image = UIImage(named: "\(name)/\(i)") {
        images.append(image)
        i += 1
    }
    return images
}

struct Animation: UIViewRepresentable {
    var name: String
    var num: Int
        
    func makeUIView(context: Self.Context) -> UIView {
        let screenSize: CGRect = UIScreen.main.bounds
        let w = screenSize.width
        let h = screenSize.height / 2
        
        let someView = UIView(frame: CGRect(x: 0, y: 0, width: w, height: h))
        let someImage = UIImageView(frame: CGRect(x: w * 0.05, y: 0, width: w * 0.9, height: h))
        someImage.clipsToBounds = true
        someImage.autoresizesSubviews = true
        someImage.contentMode = UIView.ContentMode.scaleAspectFit
        let images = animatedImages(for: name + String(num))
        someImage.image = UIImage.animatedImage(with: images, duration: Double(images.count) / 1.2)
        someView.addSubview(someImage)
        return someView
    }
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
}

struct TutorialHelperViews_Previews: PreviewProvider {
    static var previews: some View {
        TutorialHelperViews()
    }
}
