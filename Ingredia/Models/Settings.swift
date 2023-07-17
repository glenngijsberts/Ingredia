//
//  Settings.swift
//  Ingredia
//
//  Created by Glenn Gijsberts on 17/07/2023.
//

import Foundation

@MainActor class Settings: ObservableObject {
    @Published var preferredLanguage = "nl"
    
    static let languages = [Language(id: "nl", name: "Dutch"), Language(id: "en", name: "English")]
    
    var languageName: String {
        Settings.languages.first(where: { $0.id == preferredLanguage})?.name ?? "German"
    }
}
