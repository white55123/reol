//
//  SettingsView.swift
//  Reol
//
//  Created by reol on 2025/11/28.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section("设置") {
                    Text("设置选项 1")
                    Text("设置选项 2")
                    Text("设置选项 3")
                }
            }
            .navigationTitle("设置")
        }
    }
}

#Preview {
    SettingsView()
}

