//
//  FolderListViewModel.swift
//  Passwords
//
//  Created by Gustavo Soré on 18/03/25.
//

import SwiftUI
import SwiftData

class FolderListViewModel: ObservableObject {
    @Published var folders: [Folder]
    @Published var selectedFolder: Folder?
    @Published var columnVisibility: NavigationSplitViewVisibility
    @Published var selectedPassword: Password?
    @Published var isDeleting: Bool = false
    @Published var showAlert: Bool = false
    
    init(
        selectedFolder: Folder? = nil,
        columnVisibility: NavigationSplitViewVisibility,
        selectedPassword: Password? = nil
    ) {
        self.folders = []
        self.selectedFolder = selectedFolder
        self.columnVisibility = columnVisibility
        self.selectedPassword = selectedPassword
    }
    
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
            for password in folder.passwords {
                context.delete(password)
            }

            context.delete(folder)
            folders.removeAll { $0.id == folder.id }
            try context.save()
        } catch {
            print("Error deleting folder and related passwords: \(error)")
        }
    }
    
    func passwordCount(for folder: Folder) -> Int {
        return folder.passwords.count
    }
    
    func toggleDeleting() {
        isDeleting.toggle()
    }
    
    func confirmDelete(_ folder: Folder) {
        selectedFolder = folder
        showAlert = true
    }
    
    func deleteConfirmed(_ context: ModelContext) {
        guard let folder = selectedFolder else { return }
        
        context.delete(folder) // Isso já remove em cascata se o modelo estiver configurado corretamente
        do {
            try context.save()
            DispatchQueue.main.async {
                self.selectedFolder = nil
                self.showAlert = false
                self.folders.removeAll { $0.id == folder.id }
            }
        } catch {
            print("Error deleting folder: \(error)")
        }
    }
}
