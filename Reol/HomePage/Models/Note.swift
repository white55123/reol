//
//  Note.swift
//  Reol
//
//  Created by reol on 2025/11/28.
//

import Foundation

struct Note: Identifiable, Codable {
    var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date
    var isPinned: Bool
    
    init(id: UUID = UUID(), title: String = "", content: String = "", createdAt: Date = Date(), updatedAt: Date = Date(), isPinned: Bool = false) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isPinned = isPinned
    }
}

