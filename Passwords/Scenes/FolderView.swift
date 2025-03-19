//
//  FolderView.swift
//  Passwords
//
//  Created by Gustavo Soré on 18/03/25.
//

import SwiftUI

struct FolderView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: GroupViewModel
    @Binding var createNewPassword: Bool
    @Binding var createNewFolder: Bool

    
    var body: some View {
        
        
        Form {
            Section() {
                List(viewModel.folder.passwords) { password in
                    Text(password.domain)
                }
            }
        }
        .navigationTitle("\(viewModel.folder.name) Passwords")
        .toolbar {
            Button {
                createNewFolder = false
                createNewPassword = true
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
                        .foregroundColor(.blue)
            }
        }
    }
}
