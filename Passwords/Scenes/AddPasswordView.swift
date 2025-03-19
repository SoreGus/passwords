import SwiftUI
import SwiftData

struct AddPasswordView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: AddPasswordViewModel
    @State private var folders: [Folder] = []
    
    var body: some View {
        Form {
            Section("Details") {
                TextField("Domain", text: $viewModel.domain)
                TextField("User / Email", text: $viewModel.email)
                SecureField("Password", text: $viewModel.password)
            }
            
            Section("Group") {
                Picker("Select Group", selection: $viewModel.selectedFolder) {
                    Text("No Group").tag(nil as Folder?)
                    ForEach(folders) { folder in
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
    }
}

#Preview {
    AddPasswordView(viewModel: .init())
        .environment(\.colorScheme, .dark)
}
