import SwiftUI
import SwiftData

struct MainView: View {
    @State private var selectedPassword: Password?
    @State private var selectedFolder: Folder?
    @State private var createNewFolder: Bool = false
    @State private var createNewPassword: Bool = false
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    var body: some View {
        if isIpadOrMac() {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                FolderListView(
                    selectedFolder: $selectedFolder,
                    createNewFolder: $createNewFolder,
                    createNewPassword: $createNewPassword,
                    columnVisibility: $columnVisibility
                )
            } content: {
                if let selectedFolder, !createNewFolder {
                    FolderView(
                        viewModel: .init(folder: selectedFolder),
                        createNewPassword: $createNewPassword,
                        createNewFolder: $createNewFolder,
                        selectedPassword: $selectedPassword
                    )
                } else {
                    Text("Create or select a folder")
                        .onAppear { columnVisibility = .automatic }
                }
            } detail: {
                if createNewPassword {
                    AddPasswordView(viewModel: AddPasswordViewModel.init())
                        .onAppear { columnVisibility = .doubleColumn }
                } else if createNewFolder {
                    AddFolderView(viewModel: .init())
                } else if let selectedPassword {
                    PasswordView(viewModel: .init(record: selectedPassword))
                } else {
                    Text("Select a password to view details")
                        .foregroundColor(.gray)
                }
            }
        } else {
            NavigationStack {
                FolderListView(
                    selectedFolder: $selectedFolder,
                    createNewFolder: $createNewFolder,
                    createNewPassword: $createNewPassword,
                    columnVisibility: $columnVisibility
                )
                .navigationDestination(isPresented: $createNewFolder) {
                    AddFolderView(viewModel: .init())
                }
                .navigationDestination(isPresented: $createNewPassword) {
                    AddPasswordView(viewModel: AddPasswordViewModel.init())
                }
            }
        }
    }

    func isIpadOrMac() -> Bool {
        #if os(macOS)
        return true
        #else
        return UIDevice.current.userInterfaceIdiom == .pad
        #endif
    }
}
