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

    public var body: some View {
        Form {
            Section {
                List(viewModel.folders, id: \.id) { folder in
                    HStack {
                        Text(folder.name)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 10)
                        Spacer()
                        Text("\(viewModel.passwordCount(for: folder))")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        if viewModel.isDeleting {
                            Button {
                                viewModel.confirmDelete(folder)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                    .background(viewModel.selectedFolder == folder ? Color.blue.opacity(0.3) : Color.clear)
                    .foregroundColor(viewModel.selectedFolder == folder ? .blue : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        guard !viewModel.isDeleting else { return }
                        viewModel.createNewPassword = false
                        viewModel.createNewFolder = false
                        viewModel.selectedFolder = folder
                    }
                    .listRowBackground(Color.clear)
                }
            }
        }
        .navigationTitle("Folders")
        .toolbar {
            HStack {
                Button {
                    viewModel.toggleDeleting()
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.headline)
                }
                Button {
                    viewModel.createNewFolder = true
                } label: {
                    Image(systemName: "plus")
                        .font(.headline)
                }
            }
        }
        .alert("All passwords related to this folder will be deleted. Are you sure?", isPresented: $viewModel.showAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.deleteConfirmed(modelContext)
            }
        }
        .onAppear {
            viewModel.load(modelContext)
        }
    }
}
