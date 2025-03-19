//
//  AddFolderViewModel.swift
//  Passwords
//
//  Created by Gustavo Soré on 18/03/25.
//

import SwiftUI
import SwiftData

class AddFolderViewModel: ObservableObject {
    @Published var folders: [Folder] = []

    func save(folderName: String, context: ModelContext) {
        do {
            let newFolder = Folder(name: folderName)
            context.insert(newFolder)
            try context.save()
            folders.append(newFolder)
        } catch {
            print("Erro ao salvar a pasta: \(error.localizedDescription)")
        }
    }
}
