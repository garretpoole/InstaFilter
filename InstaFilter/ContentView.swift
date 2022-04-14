//
//  ContentView.swift
//  InstaFilter
//
//  Created by Garret Poole on 4/12/22.
//

import SwiftUI

struct ContentView: View {
    @State private var blurAmount = 0.0
    
    var body: some View {
        VStack {
            Text("Hello, World")
                .blur(radius: blurAmount)
            
            //adjusts $blurAmount not blurAmount so bypass the setter
            Slider(value: $blurAmount, in: 0...20)
                //applies to slider and button and .onChange can be placed anywhere in the code
                .onChange(of: blurAmount) { newVal in
                    print("New value is \(newVal)")
                }
            
            Button("Random Blur") {
                //goes through nonmutating setter so triggers the didSet
                blurAmount = Double.random(in: 0...20)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
