//
//  SettingsView.swift
//  Ingredia
//
//  Created by Glenn Gijsberts on 15/07/2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Preferred language", selection: $settings.preferredLanguage) {
                        ForEach(Settings.languages) {
                            Text($0.name)
                        }
                    }
                } header: {
                    Text("Language")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
