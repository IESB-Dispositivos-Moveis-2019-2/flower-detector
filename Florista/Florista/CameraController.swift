//
//  CameraController.swift
//  Florista
//
//  Created by Pedro Henrique on 26/07/21.
//


import Foundation
import UIKit.UIImage

class CameraController: ObservableObject {
    
    @Published
    var isPresentingPicker = false
    
    private(set) var sourceType = ImagePicker.SourceType.photoLibrary
    
    @Published
    var selectedImage: UIImage?
    
    func takePicture() {
        sourceType = .camera
        isPresentingPicker = true
    }
    
    func choosePicture() {
        sourceType = .photoLibrary
        isPresentingPicker = true
    }
    
}
