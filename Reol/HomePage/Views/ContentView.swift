//
//  ContentView.swift
//  Reol
//
//  Created by reol on 2025/11/28.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var noteManager = NoteManager()
    @State private var showSplash = true  // 独立管理启动页面显示状态
    @State private var hasStartedHiding = false  // 防止重复触发
    @State private var selectedTab = 0  // 当前选中的 Tab
    
    var body: some View {
        ZStack {
            if showSplash {
                // 启动过渡页面 - 立即显示，不依赖 NoteManager
                SplashView()
                    .transition(.opacity)
                    .zIndex(1)
            } else {
                // 主内容视图 - 使用 TabView
                TabView(selection: $selectedTab) {
                    // 首页 - 笔记列表
                    HomeView()
                        .environmentObject(noteManager)
                        .tabItem {
                            Label("首页", systemImage: "note.text")
                        }
                        .tag(0)
                    
                    // 设置页面
                    SettingsView()
                        .tabItem {
                            Label("设置", systemImage: "gearshape")
                        }
                        .tag(1)
                    
                    // 个人中心
                    ProfileView()
                        .tabItem {
                            Label("我的", systemImage: "person")
                        }
                        .tag(2)
                }
                .transition(.opacity)
                .zIndex(0)
            }
        }
        .onChange(of: noteManager.isLoading) {
            // 当数据加载完成时，延迟一点时间再隐藏启动页面
            if !noteManager.isLoading && !hasStartedHiding {
                hasStartedHiding = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showSplash = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
