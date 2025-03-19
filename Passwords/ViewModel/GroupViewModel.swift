//
//  GroupViewModel.swift
//  Passwords
//
//  Created by Gustavo Soré on 18/03/25.
//

import SwiftUI
import SwiftData

class GroupViewModel: ObservableObject {
    
    @Published var folder: Folder
    
    init(
        folder: Folder
    ) {
        self.folder = folder
    }
}
