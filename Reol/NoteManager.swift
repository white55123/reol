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
            notes = decodedNotes.sorted { $0.updatedAt > $1.updatedAt }
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
        notes.insert(note, at: 0)
        saveNotes()
    }
    
    // 更新笔记
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            var updatedNote = note
            updatedNote.updatedAt = Date()
            notes[index] = updatedNote
            notes.sort { $0.updatedAt > $1.updatedAt }
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

