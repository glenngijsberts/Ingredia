//
//  IngrediaApp.swift
//  Ingredia
//
//  Created by Glenn Gijsberts on 15/07/2023.
//

import SwiftUI

@main
struct IngrediaApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.dark)
                .accentColor(.indigo)
        }
    }
}
