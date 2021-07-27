//
//  ImagePicker.swift
//  Florista
//
//  Created by Pedro Henrique on 26/07/21.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias SourceType = UIImagePickerController.SourceType
    
    
    let sourceType: SourceType
    let completionHandler: (UIImage?) -> Void
    
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let viewController = UIImagePickerController()
        viewController.sourceType = sourceType
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(completionHandler: completionHandler)
    }
    
}

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let completionHandler: (UIImage?) -> Void
    
    init(completionHandler: @escaping (UIImage?) -> Void) {
        self.completionHandler = completionHandler
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        completionHandler(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        completionHandler(nil)
    }
    
}
