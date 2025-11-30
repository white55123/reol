//
//  NoteEditView.swift
//  Reol
//
//  Created by reol on 2025/11/28.
//

import SwiftUI

struct NoteEditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var note: Note          // 当前的笔记
    @State private var originalNote: Note  // 保存原始笔记，用于取消操作
    let noteManager: NoteManager
    @State private var isNewNote: Bool     // 改为 @State，保存后可以更新
    
    @FocusState private var isTitleFocused: Bool
    @FocusState private var isContentFocused: Bool
    @State private var showSaveSuccess = false  // 显示保存成功提示
    
    // 检查是否有内容（标题或内容不为空）
    private var hasContent: Bool {
        !note.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !note.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    init(note: Note, noteManager: NoteManager, isNewNote: Bool = false) {
        self._note = State(initialValue: note)
        self._originalNote = State(initialValue: note)
        self.noteManager = noteManager
        self._isNewNote = State(initialValue: isNewNote)
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
                    Button("返回") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveNote()
                    }
                    .fontWeight(.semibold)
                    .disabled(isNewNote && !hasContent)
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
            originalNote = note
            // 保存后，将 isNewNote 设为 false，防止重复添加
            isNewNote = false
        } else {
            noteManager.updateNote(note)
            originalNote = note
        }
        showSaveSuccess = true
        isTitleFocused = false
        isContentFocused = false
    }
    
    private func cancelEdit() {
        if isNewNote {
            dismiss()
        } else {
            note = originalNote
            isTitleFocused = false
            isContentFocused = false
        }
    }
}

#Preview {
    NoteEditView(note: Note(title: "示例笔记", content: "这是一条示例笔记内容"), noteManager: NoteManager())
}

