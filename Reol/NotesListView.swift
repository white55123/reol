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
            ZStack {
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
                } else {
                    List {
                        ForEach(filteredNotes) { note in
                            NavigationLink(destination: NoteEditView(note: note, noteManager: noteManager)) {
                                NoteRowView(note: note)
                            }
                        }
                        .onDelete(perform: deleteNotes)
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

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
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
            
            Text(note.updatedAt, style: .relative)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NotesListView()
}

