//
//  ProductAddViewModel.swift
//  Ingredia
//
//  Created by Glenn Gijsberts on 17/07/2023.
//

import SwiftUI
import OpenAIKit
import Vision

@MainActor class ProductAddViewModel: ObservableObject {
    @Published var language = "nl"
    
    @Published var textFromPhoto = ""
    
    @Published var isLoading = false
    @Published var ingredients = ""
    
    static let languages = [Language(id: "nl", name: "Dutch"), Language(id: "en", name: "English")]
    
    private let apiToken = ProcessInfo.processInfo.environment["OA_API_TOKEN"] ?? ""
    private let organizationName = ProcessInfo.processInfo.environment["OA_ORGANIZATION_NAME"] ?? ""
    
    var languageName: String {
        ProductAddViewModel.languages.first { $0.id == language }?.name ?? "German"
    }
    
    func getTextFromPhoto(_ inputImage: UIImage?) {
        do {
            guard let inputImage = inputImage else { return }
            
            let beginImage = inputImage.cgImage
            
            guard let cgImage = beginImage else { return }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            let request = VNRecognizeTextRequest { request, error in
                if let results = request.results as? [VNRecognizedTextObservation] {
                    let text = results.compactMap({
                        $0.topCandidates(1).first?.string
                    }).joined(separator: ", ")
                    
                    self.textFromPhoto = text
                }
            }
            
            request.recognitionLanguages = [language]
            request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
            
            try handler.perform([request])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getPrompt(textWithIngredients text: String, translateTo: String) -> String {
        """
        I have a text in \(languageName) that includes ingredients (but also other information maybe, which you shouldn't use in your response).
        Can you give me a list of ONLY the ingredients, in a plain string with each ingredient separated by commas.
        Do not include any other information such as product name and weight of product. Please translate in \(translateTo). This is the text: \(text)
        """
    }
    
    func getFormattedText(textWithIngredients: String, translateTo: String) async {
        let openAI = OpenAIKit(apiToken: apiToken, organization: organizationName)
        
        let prompt = getPrompt(textWithIngredients: textWithIngredients, translateTo: translateTo)
        
        let result = await openAI.sendCompletion(prompt: prompt, model: .gptV3_5(.davinciText003), maxTokens: 2048)
        
        switch result {
        case .success(let aiResult):
            if let text = aiResult.choices.first?.text {
                print(text)
                
                Task { @MainActor in
                    self.ingredients = text
                    self.isLoading = false
                }
            }
        case .failure(let error):
            print(error)
        }
    }
}
