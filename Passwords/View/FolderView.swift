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
    @Binding var selectedFolder: Folder?

    var body: some View {
        Form {
            Section {
                List(viewModel.folder.passwords) { password in
                    HStack {
                        Text(password.domain)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 10)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
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
        .navigationTitle("\(viewModel.folder.name)")
        .toolbar {
            Button {
                createNewFolder = false
                createNewPassword = true
                selectedFolder = viewModel.folder
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
    }
}
