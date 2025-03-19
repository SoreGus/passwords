//
//  PasswordViewModel.swift
//  Passwords
//
//  Created by Gustavo Soré on 18/03/25.
//

import SwiftUI
import SwiftData

class PasswordViewModel: ObservableObject {
    
    @Published var selectedPassword: Password?
    
    func load(_ context: ModelContext) {
        do {
            
        } catch {
            print(error)
        }
    }
}
