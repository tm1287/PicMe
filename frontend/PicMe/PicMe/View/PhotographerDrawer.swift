//
//  PhotographerDrawer.swift
//  PicMe
//
//  Created by Tejas Maraliga on 1/25/22.
//

import SwiftUI

struct PhotographerDrawer: View {
    @State private var offset: CGFloat = 0;
    @State private var isInitialOffsetSet: Bool = false
    var body: some View {
        GeometryReader {proxy in
            ZStack {
                BlurredView(style: .systemThinMaterial)
                VStack{
                    Capsule()
                        .frame(width: 100, height: 7)
                        .padding(.top, 7)
                    Spacer()
                }
            }
        }
        .offset(y: offset)
        .gesture(
            DragGesture()
                .onChanged({ value in
                    let startLocation = value.startLocation
                    offset = startLocation.y + value.translation.height
                    
                })
        )
        .onAppear {
            if !isInitialOffsetSet {
                offset = UIScreen.main.bounds.height - 250
                isInitialOffsetSet = true
            }
        }
    }
}

struct BlurredView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(
            effect: UIBlurEffect(style: style)
        )
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

struct PhotographerDrawer_Previews: PreviewProvider {
    static var previews: some View {
        PhotographerDrawer()
    }
}
