import SwiftUI
import SwiftData

struct MainView: View {
    @StateObject private var viewModel = FolderListViewModel()

    var body: some View {
        if isIpadOrMac() {
            NavigationSplitView(columnVisibility: $viewModel.columnVisibility) {
                FolderListView(viewModel: viewModel)
            } content: {
                if let selectedFolder = viewModel.selectedFolder, !viewModel.createNewFolder {
                    FolderView(
                        viewModel: .init(folder: selectedFolder),
                        createNewPassword: $viewModel.createNewPassword,
                        createNewFolder: $viewModel.createNewFolder,
                        selectedPassword: $viewModel.selectedPassword
                    )
                } else {
                    Text("Create or select a folder")
                        .onAppear { viewModel.columnVisibility = .automatic }
                }
            } detail: {
                if viewModel.createNewPassword {
                    AddPasswordView(viewModel: AddPasswordViewModel.init())
                        .onAppear { viewModel.columnVisibility = .doubleColumn }
                } else if viewModel.createNewFolder {
                    AddFolderView(viewModel: .init())
                } else if let selectedPassword = viewModel.selectedPassword {
                    PasswordView(viewModel: .init(record: selectedPassword))
                } else {
                    Text("Select a password to view details")
                        .foregroundColor(.gray)
                }
            }
        } else {
            NavigationStack {
                FolderListView(viewModel: viewModel)
                .navigationDestination(isPresented: $viewModel.createNewFolder) {
                    AddFolderView(viewModel: .init())
                }
                .navigationDestination(isPresented: $viewModel.createNewPassword) {
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
