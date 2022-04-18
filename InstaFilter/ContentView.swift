//
//  ContentView.swift
//  InstaFilter
//
//  Created by Garret Poole on 4/12/22.
//

import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterintensity = 0.5
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    //optional view works well with ZStack
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    //select image
                }
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterintensity)
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter") {
                        //change filter
                    }
                    Spacer()
                    Button("Save", action: save)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("InstaFilter")
        }
    }
    
    func save() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
