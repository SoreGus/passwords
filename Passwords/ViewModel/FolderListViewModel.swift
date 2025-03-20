//
//  FolderListViewModel.swift
//  Passwords
//
//  Created by Gustavo Soré on 18/03/25.
//

import SwiftUI
import SwiftData

class FolderListViewModel: ObservableObject {
    @Published var folders: [Folder] = []
    
    func load(_ context: ModelContext) {
        do {
            let fetchDescriptor = FetchDescriptor<Folder>()
            folders = try context.fetch(fetchDescriptor)
        } catch {
            print(error)
        }
    }
    
    func deleteFolder(_ folder: Folder, _ context: ModelContext) {
        do {
            // Excluir todas as senhas associadas à pasta
            for password in folder.passwords {
                context.delete(password)
            }

            // Excluir a pasta
            context.delete(folder)
            folders.removeAll { $0.id == folder.id }

            // Salvar as alterações no contexto
            try context.save()
        } catch {
            print("Error deleting folder and related passwords: \(error)")
        }
    }
}
