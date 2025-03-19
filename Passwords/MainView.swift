import SwiftUI
import SwiftData

struct MainView: View {
    
    @State private var selectedPassword: Password?
    @State private var selectedFolder: Folder?
    @State private var createNewFolder: Bool = false
    @State private var createNewPassword: Bool = false
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility)  {
            FolderListView(
                selectedFolder: $selectedFolder,
                createNewFolder: $createNewFolder,
                createNewPassword: $createNewPassword,
                columnVisibility: $columnVisibility
            )
        } content: {
            if let selectedFolder, !createNewFolder {
                FolderView(
                    viewModel: .init(
                        folder: selectedFolder
                    ),
                    createNewPassword: $createNewPassword,
                    createNewFolder: $createNewFolder
                )
            } else {
                Text("Create or select a folder")
                    .onAppear {
                        columnVisibility = .automatic
                    }
            }
        } detail: {
            if createNewPassword {
                AddPasswordView(viewModel: AddPasswordViewModel.init())
                    .onAppear {
                        columnVisibility = .doubleColumn
                    }
            } else if createNewFolder {
                AddFolderView(viewModel: .init())
            }  else {
                Text("Select a password to view details")
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    MainView()
        .environment(\.colorScheme, .dark)
}
