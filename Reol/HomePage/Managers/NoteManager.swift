//
//  NoteManager.swift
//  Reol
//
//  Created by reol on 2025/11/28.
//

import Foundation
import Combine
import SwiftUI

class NoteManager: ObservableObject {
    @Published var notes: [Note] = []
    
    private let notesKey = "SavedNotes"
    
    init() {
        loadNotes()
    }
    
    // 加载笔记
    func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: notesKey),
           let decodedNotes = try? JSONDecoder().decode([Note].self, from: data) {
            notes = sortNotes(decodedNotes)
        }
    }
    
    // 排序笔记：置顶的在前，然后按更新时间排序
    private func sortNotes(_ notes: [Note]) -> [Note] {
        return notes.sorted { note1, note2 in
            if note1.isPinned != note2.isPinned {
                return note1.isPinned
            }
            return note1.updatedAt > note2.updatedAt  // 同类型按更新时间排序
        }
    }
    
    // 保存笔记
    func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: notesKey)
        }
    }
    
    // 添加笔记
    func addNote(_ note: Note) {
        notes.append(note)
        notes = sortNotes(notes)
        saveNotes()
    }
    
    // 更新笔记
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            var updatedNote = note
            updatedNote.updatedAt = Date()
            notes[index] = updatedNote
            notes = sortNotes(notes)
            saveNotes()
        }
    }
    
    // 切换置顶状态
    func togglePin(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                notes[index].isPinned.toggle()
                notes = sortNotes(notes)
            }
            saveNotes()
        }
    }
    
    // 删除笔记
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    // 删除多个笔记
    func deleteNotes(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        saveNotes()
    }
}

