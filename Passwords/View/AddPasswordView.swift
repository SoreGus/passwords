import SwiftUI
import SwiftData

struct AddPasswordView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: AddPasswordViewModel
    @State private var showPassword = false
    
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

                HStack {
                    if showPassword {
                        TextField("Password", text: $viewModel.password)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                    }
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                if let passwordError = viewModel.passwordError {
                    Text(passwordError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button("Generate Password") {
                    viewModel.generateSecurePassword()
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
