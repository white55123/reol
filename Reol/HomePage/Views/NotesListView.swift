//
//  NotesListView.swift
//  Reol
//
//  Created by reol on 2025/11/28.
//

import SwiftUI

struct NotesListView: View {
    @StateObject private var noteManager = NoteManager()
    @State private var searchText = ""
    @State private var showingNewNote = false
    
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
            Group {
                if filteredNotes.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "note.text")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
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
                    List {
                        ForEach(filteredNotes) { note in
                            NoteRow(note: note, noteManager: noteManager)
                                .id("\(note.id)-\(note.isPinned)")
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("记事本")
            .searchable(text: $searchText, prompt: "搜索笔记")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNewNote = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewNote) {
                NoteEditView(note: Note(), noteManager: noteManager, isNewNote: true)
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

#Preview {
    NotesListView()
}


