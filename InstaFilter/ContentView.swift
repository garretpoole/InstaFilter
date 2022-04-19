//
//  ContentView.swift
//  InstaFilter
//
//  Created by Garret Poole on 4/12/22.
//
//App uses SwiftUI, CoreImage, PHPickerViewController

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    
    @State private var filterintensity = 0.5
    @State private var filterradius = 0.5
    @State private var filterscale = 0.5
    @State private var filteramount = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    @State private var processedImage: UIImage?
    //must specify general CIFilter bc "=" means it has to conform to sepiaTone as well
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    //context take a lot of work to reate so just create once and keep alive
    let context = CIContext()
    
    //allow save
    @State private var cannotSave = true
    
    @State private var showingFilterSheet = false
    
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
                    showingImagePicker = true
                }
                ForEach(currentFilter.inputKeys, id: \.self) { inputKey in
                    if inputKey == kCIInputIntensityKey {
                        HStack{
                            Text("Intensity")
                            //changing binding directly doesnt reinvoke body property
                            //so need onChange for ui to update
                            Slider(value: $filterintensity)
                                .onChange(of: filterintensity) { _ in applyProcessing() }
                        }
                        .padding(.vertical)
                    }
                    if inputKey == kCIInputRadiusKey {
                        HStack{
                            Text("Radius")
                            Slider(value: $filterradius)
                                .onChange(of: filterradius) { _ in applyProcessing() }
                        }
                        .padding(.vertical)
                    }
                    if inputKey == kCIInputScaleKey {
                        HStack{
                            Text("Scale")
                            Slider(value: $filterscale)
                                .onChange(of: filterscale) { _ in applyProcessing() }
                        }
                        .padding(.vertical)
                    }
                    if inputKey == kCIInputAmountKey {
                        HStack{
                            Text("Amount")
                            Slider(value: $filteramount)
                                .onChange(of: filteramount) { _ in applyProcessing() }
                        }
                        .padding(.vertical)
                    }
                }
                
                HStack {
                    Button("Change Filter") {
                        showingFilterSheet = true
                    }
                    Spacer()
                    Button("Save", action: save)
                        .disabled(cannotSave)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("InstaFilter")
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage, cannotSave: $cannotSave)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vibrance") { setFilter(CIFilter.vibrance()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Invert") { setFilter(CIFilter.colorInvert()) }
                Button("Bloom") { setFilter(CIFilter.bloom()) }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        //kCIInputImageKey is stringly typed behind the scenes
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func save() {
        guard let processedImage = processedImage else { return }
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print("Success!")
        }
        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }
        imageSaver.writeToPhotoAlbum(image: processedImage)

    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        //changed bc .intenstiy came from the sepiaTone type conformation
        //need safety for different filters (some dont have intensity)
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterintensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterradius*100, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterscale*10, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIInputAmountKey) {
            currentFilter.setValue(filteramount*10, forKey: kCIInputAmountKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
