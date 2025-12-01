//
//  HomeView.swift
//  Reol
//
//  Created by reol on 2025/11/28.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var noteManager: NoteManager
    
    var body: some View {
        NotesListView()
    }
}

#Preview {
    HomeView()
        .environmentObject(NoteManager())
}

