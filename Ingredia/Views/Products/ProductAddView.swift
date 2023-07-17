//
//  ProductAddView.swift
//  Ingredia
//
//  Created by Glenn Gijsberts on 15/07/2023.
//

import SwiftUI
import Vision
import OpenAIKit

struct ProductAddView: View {
    @StateObject var viewModel = ProductAddViewModel()
    @EnvironmentObject var settings: Settings
    @Environment()
    
    @Binding var image: UIImage?
    
    @State private var showIngredients = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Image(uiImage: image ?? UIImage(imageLiteralResourceName: "image_chips"))
                        .resizable()
                        .scaledToFit()
                }
                
                Section {
                    Picker("Language of product?", selection: $viewModel.language) {
                        ForEach(ProductAddViewModel.languages) {
                            Text($0.name)
                        }
                    }
                } header: {
                    Text("Language")
                }
                
                Button {
                    viewModel.isLoading = true
                    
                    viewModel.getTextFromPhoto(image)

                    Task {
                        await viewModel.getFormattedText(textWithIngredients: viewModel.textFromPhoto, translateTo: settings.languageName)
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Get ingredients list")
                    }
                }
            }
            .onChange(of: viewModel.ingredients, perform: { _ in
                showIngredients = true
            })
            .sheet(isPresented: $showIngredients) {
                VStack {
                    Text(viewModel.ingredients)
                }
            }
            .navigationTitle("Additional info")
        }
    }
}

struct ProductAddView_Previews: PreviewProvider {
    static var previews: some View {
        ProductAddView(image: .constant(UIImage(imageLiteralResourceName: "image_chips")))
            .preferredColorScheme(.dark)
    }
}
