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
    @Binding var columnVisibility: NavigationSplitViewVisibility

    public var body: some View {
        Form {
            Section() {
                List(viewModel.folders) { folder in
                    HStack {
                        Button {
                            createNewPassword = false
                            createNewFolder = false
                            selectedFolder = folder
                        } label: {
                            Text(folder.name)
                        }
                    }
                }
            }
        }
        .navigationTitle("Folders")
        .toolbar {
            Button {
                createNewPassword = false
                createNewFolder = true
                columnVisibility = .detailOnly
            } label: {
                Image(systemName: "plus")
                    .font(.headline)
                        .foregroundColor(.blue)
            }
        }.onAppear {
            viewModel.load(modelContext)
        }
    }
}

#Preview {
    
    @Previewable @State var selectedPassword: Password?
    @Previewable @State var selectedFolder: Folder?
    @Previewable @State var createNewFolder: Bool = false
    @Previewable @State var createNewPassword: Bool = false
    @Previewable @State var columnVisibility: NavigationSplitViewVisibility = .all
    
    NavigationStack {
        FolderListView(
            selectedFolder: $selectedFolder,
            createNewFolder: $createNewFolder,
            createNewPassword: $createNewPassword,
            columnVisibility: $columnVisibility
        )
            .environment(\.colorScheme, .dark)
    }
}
