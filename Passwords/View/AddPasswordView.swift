import SwiftUI
import SwiftData

struct AddPasswordView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: AddPasswordViewModel
    
    var body: some View {
        Form {
            Section("Details") {
                TextField("Domain / Host", text: $viewModel.domain)
                if let domainError = viewModel.domainError {
                    Text(domainError)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                TextField("User / Email", text: $viewModel.email)
                if let emailError = viewModel.emailError {
                    Text(emailError)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                SecureField("Password", text: $viewModel.password)
                if let passwordError = viewModel.passwordError {
                    Text(passwordError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
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
