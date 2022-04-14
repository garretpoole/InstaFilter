//
//  ContentView.swift
//  InstaFilter
//
//  Created by Garret Poole on 4/12/22.
//

import SwiftUI

struct ContentView: View {
    //State property wrapper has wrapped value with nonmutating set
    //when set the value it wont change the state of the struct itself
    @State private var blurAmount = 0.0 {
        didSet {
            //doesnt print when using slider bc @State wraps contents in new struct
            //so only prints when the state struct that contains the blur amount changes then print
            print("New value is \(blurAmount)")
        }
    }
    
    var body: some View {
        VStack {
            Text("Hello, World")
                .blur(radius: blurAmount)
            
            //adjusts $blurAmount not blurAmount so bypass the setter
            Slider(value: $blurAmount, in: 0...20)
            
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
