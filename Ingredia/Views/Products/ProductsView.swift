//
//  ProductsView.swift
//  Ingredia
//
//  Created by Glenn Gijsberts on 15/07/2023.
//

import SwiftUI
import OpenAIKit

struct ProductsView: View {
    @State private var inputImage: UIImage?
    
    @State private var showCameraSheet = false
    @State private var showProductAddView = false
    
    var body: some View {
        NavigationStack {
            List {
                VStack(alignment: .leading) {
                    Text("Paprika powder")
                        .fontWeight(.semibold)
                    Text("3 ingredients")
                        .foregroundColor(.secondary)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        showCameraSheet.toggle()
                    } label: {
                        Label("Scan", systemImage: "camera.fill")
                    }
                }
            }
            .sheet(isPresented: $showCameraSheet) {
                CameraView(
                    image: $inputImage,
                    onCancel: {
                        showCameraSheet = false
                    },
                    onComplete: {
                        showProductAddView = true
                    }
                )
                .sheet(isPresented: $showProductAddView, onDismiss: {
                    showCameraSheet = false
                }) {
                    ProductAddView(image: $inputImage)
                }
            }
            .navigationTitle("Products")
        }
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
    }
}
