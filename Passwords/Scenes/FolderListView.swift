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
    @StateObject var viewModel = FolderListViewModel()
    @Binding var selectedFolder: Folder?
    @Binding var createNewFolder: Bool
    @Binding var createNewPassword: Bool
    @Binding var columnVisibility: NavigationSplitViewVisibility

    public var body: some View {
        Form {
            Section {
                List(viewModel.folders) { folder in
                    HStack {
                        Text(folder.name)
                            .padding(.vertical, 4) // Reduzindo o padding vertical
                            .padding(.horizontal, 10) // Ajustando o padding horizontal
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4) // Reduzindo o padding vertical da row
                    .background(selectedFolder == folder ? Color.blue.opacity(0.3) : Color.clear)
                    .foregroundColor(selectedFolder == folder ? .blue : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .contentShape(Rectangle()) // Expande a área de toque para toda a linha
                    .onTapGesture {
                        createNewPassword = false
                        createNewFolder = false
                        selectedFolder = folder
                    }
                    .listRowBackground(Color.clear)
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
