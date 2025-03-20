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
    @ObservedObject var viewModel: FolderViewModel
    @Binding var createNewPassword: Bool
    @Binding var createNewFolder: Bool
    @Binding var selectedPassword: Password?

    var body: some View {
        Form {
            Section {
                List(viewModel.folder.passwords) { password in
                    HStack {
                        Text(password.domain)
                            .padding(.vertical, 4) // Reduzindo o padding vertical
                            .padding(.horizontal, 10) // Ajustando o padding horizontal
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4) // Reduzindo o padding vertical da row
                    .background(selectedPassword == password ? Color.blue.opacity(0.3) : Color.clear)
                    .foregroundColor(selectedPassword == password ? .blue : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        createNewFolder = false
                        createNewPassword = false
                        selectedPassword = password
                    }
                    .listRowBackground(Color.clear)
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
