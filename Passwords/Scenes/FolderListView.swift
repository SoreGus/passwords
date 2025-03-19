//
//  FolderListView.swift
//  Passwords
//
//  Created by Gustavo Soré on 18/03/25.
//

import SwiftUI

public struct FolderListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = GroupListViewModel()
    @Binding var selectedFolder: Folder?
    @Binding var createNewFolder: Bool
    @Binding var createNewPassword: Bool

    public var body: some View {
        VStack {
            List(viewModel.folders) { folder in
                Button {
                    selectedFolder = folder
                    createNewPassword = false
                    createNewFolder = false
                } label: {
                    Text(folder.name)
                }
            }
            .navigationTitle("Folders")
            .toolbar {
                Button {
                    createNewPassword = false
                    createNewFolder = true
                } label: {
                    Image(systemName: "plus")
                        .font(.headline)
                            .foregroundColor(.blue)
                }
            }
        }.onAppear {
            viewModel.load(modelContext)
        }
    }
}
