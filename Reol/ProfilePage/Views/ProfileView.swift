//
//  ProfileView.swift
//  Reol
//
//  Created by reol on 2025/11/28.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.gray)
                
                Text("个人中心")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("这里是个人中心页面")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("我的")
        }
    }
}

#Preview {
    ProfileView()
}

