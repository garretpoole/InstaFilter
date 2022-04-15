//
//  ImageSaver.swift
//  InstaFilter
//
//  Created by Garret Poole on 4/14/22.
//

import UIKit

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        //second param nil must be class that inherits NSObject
        //third is method name on the object
        //fourth is context, can provide whatever you want
        //UIImageWriteToSavedPhotosAlbum(inputImage, nil, nil, nil)
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save Finished!")
    }
}
