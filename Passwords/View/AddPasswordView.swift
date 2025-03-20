import SwiftUI
import SwiftData

struct AddPasswordView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: AddPasswordViewModel
    
    var body: some View {
        Form {
            Section("Details") {
                TextField("Domain", text: $viewModel.domain)
                TextField("User / Email", text: $viewModel.email)
                SecureField("Password", text: $viewModel.password)
            }
            
            Section("Group") {
                Picker("Select Group", selection: $viewModel.selectedFolder) {
                    ForEach(viewModel.folders, id: \.id) { folder in
                        Text(folder.name).tag(folder as Folder?)
                    }
                }
            }
            
            Button("Save") {
                viewModel.savePassword(modelContext)
                dismiss()
            }
        }
        .navigationTitle("New Password")
        .onAppear {
            viewModel.fetchFolders(modelContext)
        }
    }
}
