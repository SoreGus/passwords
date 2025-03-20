import SwiftUI
import SwiftData

struct PasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @ObservedObject var viewModel: PasswordRegisterViewModel
    @Query private var folders: [Folder]

    var body: some View {
        Form {
            Section("Details") {
                Text("Domain: \(viewModel.domain)")
                Text("Username / E-mail: \(viewModel.username)")
                Text("Created at: \(viewModel.createdAt)")
            }

            Section("Password") {
                if let decryptedPassword = viewModel.decryptedPassword, viewModel.showPassword {
                    HStack {
                        Text(decryptedPassword)
                            .textSelection(.enabled)
                            .font(.title)
                            .onTapGesture {
                                viewModel.copyToClipboard(decryptedPassword)
                            }

                        Button(action: {
                            viewModel.copyToClipboard(decryptedPassword)
                        }) {
                            Image(systemName: viewModel.copied ? "checkmark.circle.fill" : "doc.on.doc")
                                .foregroundColor(viewModel.copied ? .green : .primary)
                                .animation(.easeInOut(duration: 0.5), value: viewModel.copied)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                } else {
                    Button("Tap to View Password") {
                        viewModel.authenticateUser()
                    }
                }
            }

            Section("Change Group") {
                Picker("Select Group", selection: $viewModel.selectedFolder) {
                    ForEach(folders) { folder in
                        Text(folder.name).tag(folder as Folder?)
                    }
                }
                .onChange(of: viewModel.selectedFolder) { _, newGroup in
                    viewModel.updateGroup(
                        newGroup,
                        modelContext: modelContext
                    )
                }
            }

            Section("Access History") {
                if viewModel.accessHistory.isEmpty {
                    Text("No access history")
                } else {
                    ForEach(viewModel.accessHistory, id: \.self) { date in
                        Text(date.formatted(date: .long, time: .shortened))
                    }
                }
            }
        }
        .navigationTitle("Password Details")
        .alert("Authentication Failed", isPresented: $viewModel.authenticationError) {
            Button("OK", role: .cancel) {}
        }
    }
}
