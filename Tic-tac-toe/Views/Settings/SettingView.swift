//
//  SettingView.swift
//  Tic-tac-toe
//
//  Created by Alexander Ognerubov on 06.02.2026.
//


import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject var appSetting: AppSetting
    
    @State private var selectedLanguage: AppLanguage = .en
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Language")) {
                    ForEach(AppLanguage.allCases) { lang in
                        HStack {
                            Text(lang.displayName)
                            Spacer()
                            if lang == selectedLanguage {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.primary)
                            }
                        }
                        .background(.white.opacity(0.001))
                        .onTapGesture {
                            Task { @MainActor in
                                selectedLanguage = lang
                                appSetting.language = selectedLanguage
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .id(appSetting.language.id)
        .onAppear {
            selectedLanguage = appSetting.language
        }
    }
}

#Preview {
    SettingView()
        .environmentObject(AppSetting())
}
