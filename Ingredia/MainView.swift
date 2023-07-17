//
//  MainView.swift
//  Ingredia
//
//  Created by Glenn Gijsberts on 15/07/2023.
//

import SwiftUI

struct MainView: View {
    @StateObject var settings = Settings()
    
    var body: some View {
        TabView {
            ProductsView()
                .tabItem {
                    Label("Products", systemImage: "books.vertical")
                        .tint(.green)
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "person.crop.circle")
                }
        }
        .environmentObject(settings)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
