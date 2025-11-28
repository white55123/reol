//
//  NoteEditView.swift
//  Reol
//
//  Created by reol on 2025/11/28.
//

import SwiftUI

struct NoteEditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var note: Note
    let noteManager: NoteManager
    let isNewNote: Bool
    
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isContentFocused: Bool
    
    init(note: Note, noteManager: NoteManager, isNewNote: Bool = false) {
        self._note = State(initialValue: note)
        self.noteManager = noteManager
        self.isNewNote = isNewNote
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TextField("标题", text: $note.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .focused($isTitleFocused)
                
                Divider()
                
                TextEditor(text: $note.content)
                    .padding(.horizontal, 8)
                    .focused($isContentFocused)
            }
            .navigationTitle(isNewNote ? "新建笔记" : "编辑笔记")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveNote()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                if isNewNote {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isTitleFocused = true
                    }
                }
            }
        }
    }
    
    private func saveNote() {
        if isNewNote {
            noteManager.addNote(note)
        } else {
            noteManager.updateNote(note)
        }
        dismiss()
    }
}

#Preview {
    NoteEditView(note: Note(title: "示例笔记", content: "这是一条示例笔记内容"), noteManager: NoteManager())
}

