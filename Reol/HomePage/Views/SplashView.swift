//
//  SplashView.swift
//  Reol
//
//  Created by reol on 2025/11/28.
//

import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // 背景渐变
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.98, green: 0.99, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // 应用图标/Logo
                ZStack {
                    // 背景圆圈
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue.opacity(0.2),
                                    Color.purple.opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .blur(radius: 20)
                    
                    // 主图标
                    Image("wusaqi1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotation))
                }
                .scaleEffect(scale)
                .opacity(opacity)
                
                // 应用名称
                VStack(spacing: 8) {
                    Text("Reol")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.blue,
                                    Color.purple
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(opacity)
                    
                    Text("记录生活的每一刻")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary)
                        .opacity(opacity * 0.8)
                }
                
                // 加载指示器
                ProgressView()
                    .scaleEffect(1.2)
                    .tint(.blue)
                    .opacity(opacity)
            }
        }
        .onAppear {
            // 启动动画：淡入和缩放
            withAnimation(.easeOut(duration: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
            
            // 延迟启动旋转动画，让初始动画更自然
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(
                    Animation.linear(duration: 3.0)
                        .repeatForever(autoreverses: false)
                ) {
                    rotation = 360
                }
            }
        }
    }
}

#Preview {
    SplashView()
}

