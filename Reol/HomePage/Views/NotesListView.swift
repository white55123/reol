//
//  NotesListView.swift
//  Reol
//
//  Created by reol on 2025/11/28.
//

import SwiftUI

// 聊天框数据模型
struct ChatBubbleData: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
}

struct NotesListView: View {
    @EnvironmentObject var noteManager: NoteManager
    @State private var searchText = ""
    @State private var showingNewNote = false
    @State private var chatBubbles: [ChatBubbleData] = []  // 存储多个聊天框
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return noteManager.notes
        } else {
            return noteManager.notes.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // 笔记统计文本
                    if searchText.isEmpty {
                        HStack {
                            Text("\(noteManager.notes.count)篇笔记")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            Spacer()
                        }
                        .background(Color(.systemBackground))
                    }
                    
                    // 主内容
                    Group {
                        if filteredNotes.isEmpty {
                            // 空状态：没有笔记或搜索无结果
                            VStack(spacing: 20) {
                                Image("wusaqi2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                Text(searchText.isEmpty ? "还没有笔记" : "没有找到匹配的笔记")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                if searchText.isEmpty {
                                    Text("点击右上角的 + 按钮创建第一条笔记")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            // 有笔记：显示列表
                            List {
                                ForEach(filteredNotes) { note in
                                    NoteRow(note: note, noteManager: noteManager)
                                        .id("\(note.id)-\(note.isPinned)")
                                }
                            }
                            .listStyle(.plain)
                        }
                    }
                }
                .navigationTitle("记事本")
                .searchable(text: $searchText, prompt: "搜索笔记")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            // 生成随机位置（避免在导航栏和边缘区域）
                            let minX: CGFloat = 50
                            let maxX = geometry.size.width - 150
                            let minY: CGFloat = 100
                            let maxY = geometry.size.height - 100
                            
                            let randomX = CGFloat.random(in: minX...maxX)
                            let randomY = CGFloat.random(in: minY...maxY)
                            
                            let newBubble = ChatBubbleData(x: randomX, y: randomY)
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                chatBubbles.append(newBubble)
                            }
                            
                            // 3秒后自动消失
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    chatBubbles.removeAll { $0.id == newBubble.id }
                                }
                            }
                        }) {
                            Image("wusaqi4")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingNewNote = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .overlay {
                    // 显示所有聊天框
                    ForEach(chatBubbles) { bubble in
                        ChatBubbleView(text: "哈？")
                            .position(x: bubble.x, y: bubble.y)
                            .transition(.scale(scale: 0.8).combined(with: .opacity))
                    }
                }
                .sheet(isPresented: $showingNewNote) {
                    NoteEditView(note: Note(), noteManager: noteManager, isNewNote: true)
                }
            }
        }
    }
    
    private func deleteNotes(at offsets: IndexSet) {
        let notesToDelete = offsets.map { filteredNotes[$0] }
        for note in notesToDelete {
            noteManager.deleteNote(note)
        }
    }
}

// 笔记行容器
struct NoteRow: View {
    let note: Note
    @ObservedObject var noteManager: NoteManager
    
    // 实时获取最新的 note 数据
    var currentNote: Note {
        noteManager.notes.first(where: { $0.id == note.id }) ?? note
    }
    
    var body: some View {
        NavigationLink(destination: NoteEditView(note: currentNote, noteManager: noteManager)) {
            NoteRowView(note: currentNote)
        }
        .listRowBackground(currentNote.isPinned ? Color.yellow.opacity(0.2) : Color.clear)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            // 删除按钮
            Button(role: .destructive) {
                noteManager.deleteNote(currentNote)
            } label: {
                Label("删除", systemImage: "trash")
            }
            
            // 置顶/取消置顶按钮
            PinButton(note: currentNote, noteManager: noteManager)
        }
    }
}

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                Text(note.title.isEmpty ? "无标题" : note.title)
                    .font(.headline)
                    .lineLimit(1)
                
                if !note.content.isEmpty {
                    Text(note.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack(spacing: 4) {
                    Text(note.createdAt, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if note.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// 置顶按钮视图
struct PinButton: View {
    let note: Note
    @ObservedObject var noteManager: NoteManager
    
    var currentNote: Note {
        noteManager.notes.first(where: { $0.id == note.id }) ?? note
    }
    
    var body: some View {
        Button {
            noteManager.togglePin(note)
        } label: {
            Label(currentNote.isPinned ? "取消置顶" : "置顶",
                  systemImage: currentNote.isPinned ? "pin.slash" : "pin.fill")
        }
        .tint(currentNote.isPinned ? .orange : .blue)
    }
}

// 聊天框视图
struct ChatBubbleView: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text(text)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(red: 1.0, green: 0.95, blue: 0.8))  // 浅黄色
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                )
            
            // 聊天框小尾巴
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: -8, y: 8))
                path.addLine(to: CGPoint(x: 0, y: 16))
            }
            .fill(Color(red: 1.0, green: 0.95, blue: 0.8))  // 浅黄色
            .frame(width: 8, height: 16)
        }
    }
}

#Preview {
    NotesListView()
        .environmentObject(NoteManager())
}


