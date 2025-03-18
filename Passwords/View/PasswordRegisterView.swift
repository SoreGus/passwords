import SwiftUI
import LocalAuthentication
import SwiftData

struct PasswordRegisterView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let record: Password
    @Query private var groups: [Group]
    
    @State private var decryptedPassword: String?
    @State private var showPassword = false
    @State private var authenticationError = false
    @State private var selectedGroup: Group?
    @State private var copied = false
    
    var body: some View {
        Form {
            Section("Details") {
                Text("Domain: \(record.domain)")
                Text("Username / E-mail: \(record.username)")
                Text("Created at: \(record.createdAt.formatted(date: .long, time: .shortened))")
            }
            
            Section("Password") {
                if let decryptedPassword, showPassword {
                    HStack {
                        Text(decryptedPassword)
                            .textSelection(.enabled)
                            .font(.title)
                            .onTapGesture {
                                copyToClipboard(decryptedPassword)
                            }
                        
                        Button(action: {
                            copyToClipboard(decryptedPassword)
                        }) {
                            Image(systemName: copied ? "checkmark.circle.fill" : "doc.on.doc")
                                .foregroundColor(copied ? .green : .primary)
                                .animation(.easeInOut(duration: 0.5), value: copied)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                } else {
                    Button("Tap to View Password") {
                        authenticateUser()
                    }
                }
            }
            
            Section("Change Group") {
                Picker("Select Group", selection: $selectedGroup) {
                    Text("No Group").tag(nil as Group?)
                    ForEach(groups) { group in
                        Text(group.name).tag(group as Group?)
                    }
                }
                .onChange(of: selectedGroup) { _, newGroup in
                    updateGroup(newGroup)
                }
            }
            
            Section("Access History") {
                if record.accessHistory.isEmpty {
                    Text("No access history")
                } else {
                    ForEach(record.accessHistory, id: \.self) { date in
                        Text(date.formatted(date: .long, time: .shortened))
                    }
                }
            }
        }
        .navigationTitle("Password Details")
        .onAppear {
            selectedGroup = record.group
        }
        .alert("Authentication Failed", isPresented: $authenticationError) {
            Button("OK", role: .cancel) {}
        }
    }
    
    private func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Authenticate to view the password"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    if success {
                        decryptPassword()
                    } else {
                        authenticationError = true
                    }
                }
            }
        } else {
            authenticationError = true
        }
    }
    
    private func decryptPassword() {
        Task {
            do {
//                let password = try await SecureStorageWorker.shared.decryptPassword(record.encryptedPassword)
//                decryptedPassword = password
                decryptedPassword = "1234554321"
                showPassword = true
            } catch {
                print("Decryption error: \(error)")
            }
        }
    }
    
    private func updateGroup(_ newGroup: Group?) {
        record.group = newGroup
        try? modelContext.save()
    }
    
    private func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
        copied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            copied = false
        }
    }
}
