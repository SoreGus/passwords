//
//  PasswordView.swift
//  Passwords
//
//  Created by Gustavo Soré on 18/03/25.
//

import SwiftUI

struct PasswordView: View {
    
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModel = PasswordViewModel()
    
    var body: some View {
        if let selectedPassword = viewModel.selectedPassword {
            PasswordRegisterView(record: selectedPassword)
        } else {
            Text("Select a password to view details")
                .foregroundColor(.gray)
        }
    }
}
