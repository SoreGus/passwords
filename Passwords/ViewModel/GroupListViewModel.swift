//
//  GroupListViewModel.swift
//  Passwords
//
//  Created by Gustavo Soré on 18/03/25.
//

import SwiftUI
import SwiftData

class GroupListViewModel: ObservableObject {
    @Published var folders: [Folder] = []
    
    func load(_ context: ModelContext) {
        do {
            let fetchDescriptor = FetchDescriptor<Folder>()
            folders = try context.fetch(fetchDescriptor)
        } catch {
            print(error)
        }
    }
}
