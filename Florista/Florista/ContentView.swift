//
//  ContentView.swift
//  Florista
//
//  Created by Pedro Henrique on 26/07/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject
    var pickerViewModel = CameraController()
    
    @ObservedObject
    var detectorViewModel = FlowerDetector()
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            VStack {
                Text("Coloque a foto de uma flor para detectar a espécie")
                
                if detectorViewModel.loading {
                    VStack(alignment: .center) {
                        Spacer()
                        ProgressView()
                        Text("Aguarde... identificando flor...")
                        Spacer()
                    }
                }else {
                    if let selectedImage = pickerViewModel.selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                        
                        if let species = detectorViewModel.species {
                            Text(species)
                        }
                        
                    }else {
                        Image("flower_placeholder")
                            .resizable()
                            .scaledToFit()
                    }
                    
                    HStack {
                        Button("Usar a câmera") {
                            pickerViewModel.takePicture()
                        }
                        Spacer()
                        Button("Escolher da biblioteca") {
                            pickerViewModel.choosePicture()
                        }
                    }
                }
                
            }
            .padding()
            .navigationTitle("Florista")
            .fullScreenCover(isPresented: $pickerViewModel.isPresentingPicker, content: {
                ImagePicker(sourceType: pickerViewModel.sourceType) { image in
                    if let img = image {
                        detectorViewModel.onImageSelected(img)
                        pickerViewModel.selectedImage = img
                    }
                    pickerViewModel.isPresentingPicker = false
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
