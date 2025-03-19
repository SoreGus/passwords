import SwiftUI
import SwiftData

struct MainView: View {
    
    @State private var selectedPassword: Password?
    @State private var selectedFolder: Folder?
    @State private var createNewFolder: Bool = false
    @State private var createNewPassword: Bool = false
    
    var body: some View {
        NavigationSplitView {
            FolderListView(
                selectedFolder: $selectedFolder,
                createNewFolder: $createNewFolder,
                createNewPassword: $createNewPassword
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
            }
        } detail: {
            if createNewPassword {
                AddPasswordView()
            } else if createNewFolder {
                AddGroupView()
            }  else {
                Text("Select a password to view details")
                    .foregroundColor(.gray)
            }
        }
    }
}
