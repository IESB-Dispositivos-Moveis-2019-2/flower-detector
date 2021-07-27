//
//  FlowerDetector.swift
//  Florista
//
//  Created by Pedro Henrique on 26/07/21.
//

import UIKit
import Foundation
import CoreML
import Vision


class FlowerDetector: ObservableObject {
    
    @Published
    private(set) var species: String? {
        didSet {
            loading = false
        }
    }
    
    @Published
    private(set) var loading = false
    
    private var flowerClassificationRequest: VNRequest?
    
    init() {
        setupModel()
    }
    
    private func setupModel() {
        let configuration = MLModelConfiguration()
        configuration.allowLowPrecisionAccumulationOnGPU = true
        
        if let model = try? VNCoreMLModel(for: turi_gender_detector(configuration: configuration).model) {
            flowerClassificationRequest = VNCoreMLRequest(
                model: model,
                completionHandler: handleFlowerClassification(request:error:)
            )
        }
    }
    
    
    private func handleFlowerClassification(request: VNRequest, error: Error?) {
        guard error == nil else { debugPrint(error!); return }
        
        var text = ""
        for result in request.results ?? [] {
            if let observation = result as? VNClassificationObservation {
                text.append("Espécie: \(observation.identifier), com confiança \(observation.confidence * 100)%\n")
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self!.species = text
        }
        
    }
    
    func onImageSelected(_ image: UIImage) {
        loading = true
        if let cg = image.cgImage {
            let ci = CIImage(cgImage: cg)
            DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
                self.classify(image: ci)
            }
        }
        
    }
    
    private func classify(image: CIImage) {
        guard let request = flowerClassificationRequest else { return }
        
        do {
            let handler = VNImageRequestHandler(ciImage: image)
            try handler.perform([request])
        }catch {
            debugPrint(error)
        }
    }
    
}
