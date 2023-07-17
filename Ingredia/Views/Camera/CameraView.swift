//
//  CameraView.swift
//  Ingredia
//
//  Created by Glenn Gijsberts on 15/07/2023.
//

import Foundation
import UIKit
import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onCancel: () -> Void
    var onComplete: () -> Void
    
    typealias UIViewControllerType = UIImagePickerController
    
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraView
        var onCancel: () -> Void
        var onComplete: () -> Void
        
        init(_ parent: CameraView) {
            self.parent = parent
            self.onCancel = parent.onCancel
            self.onComplete = parent.onComplete
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onCancel()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.parent.image = image
                
                onComplete()
            }
        }
    }
    
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIViewControllerType()
        viewController.delegate = context.coordinator
        viewController.sourceType = .camera
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> CameraView.Coordinator {
        return Coordinator(self)
    }
}
