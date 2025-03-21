import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @State var columnVisibility: NavigationSplitViewVisibility = .all
    @State var selectedFolder: Folder?
    @State var selectedPassword: Password?
    @State var createNewFolder: Bool = false
    @State var createNewPassword: Bool = false
    
    @ObservedObject private var folderListViewModel = FolderListViewModel(
        columnVisibility: .all
    )
    @ObservedObject private var folderViewModel = FolderViewModel(
        folder: .init(name: "A")
    )
    
    func folderViewModel(
        folder: Folder
    ) -> FolderViewModel {
        return .init(
            folder: folder
        )
    }

    var body: some View {
        if isIpadOrMac() {
            NavigationSplitView(columnVisibility: $columnVisibility) {
                FolderListView(
                    viewModel: folderListViewModel,
                    createNewFolder: $createNewFolder,
                    createNewPassword: $createNewPassword
                )
            } content: {
                if let selectedFolder = folderListViewModel.selectedFolder, !createNewFolder {
                    FolderView(
                        viewModel: folderViewModel(folder: selectedFolder),
                        createNewPassword: $createNewPassword,
                        createNewFolder: $createNewFolder,
                        selectedPassword: $selectedPassword,
                        selectedFolder: $selectedFolder
                    )
                } else {
                    Text("Create or select a folder")
                        .onAppear { columnVisibility = .automatic }
                }
            } detail: {
                if createNewPassword && !createNewFolder {
                    AddPasswordView(
                        viewModel: AddPasswordViewModel.init(
                            context: modelContext,
                            selectedfolder: selectedFolder,
                            selectedPassword: $selectedPassword,
                            createNewPassword: $createNewPassword
                        )
                    )
                    .onAppear { columnVisibility = .doubleColumn }
                } else if createNewFolder {
                    AddFolderView(viewModel: .init())
                } else if let selectedPassword = selectedPassword {
                    PasswordView(
                        viewModel: .init(
                            record: selectedPassword,
                            selectedPassword: $selectedPassword
                        )
                    )
                } else {
                    Text("Select a password to view details")
                        .foregroundColor(.gray)
                }
            }
        } else {
            Text("Not Implemented")
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
