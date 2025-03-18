import SwiftUI
import LocalAuthentication
import SwiftData

struct PasswordRegisterView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let record: PasswordRecord
    @Query private var groups: [GroupRecord]  // Carrega os grupos disponíveis
    
    @State private var decryptedPassword: String?
    @State private var showPassword = false
    @State private var authenticationError = false
    @State private var selectedGroup: GroupRecord?
    
    var body: some View {
        Form {
            Section("Details") {
                Text("Domain: \(record.domain)")
                Text("Email: \(record.email)")
                Text("Username: \(record.username)")
                Text("Created at: \(record.createdAt.formatted(date: .long, time: .shortened))")
            }
            
            Section("Password") {
                if let decryptedPassword, showPassword {
                    Text(decryptedPassword)
                        .textSelection(.enabled)
                        .font(.title)
                } else {
                    Button("Tap to View Password") {
                        authenticateUser()
                    }
                }
            }
            
            Section("Change Group") {
                Picker("Select Group", selection: $selectedGroup) {
                    Text("No Group").tag(nil as GroupRecord?)
                    ForEach(groups) { group in
                        Text(group.name).tag(group as GroupRecord?)
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
    
    /// Método para autenticar usuário antes de mostrar a senha
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
    
    /// Método para descriptografar a senha
    private func decryptPassword() {
        Task {
            do {
                let password = try SecureStorageWorker.shared.decryptPassword(record.encryptedPassword)
                decryptedPassword = password
                showPassword = true
            } catch {
                print("Decryption error: \(error)")
            }
        }
    }
    
    /// Método para mudar a senha de grupo
    private func updateGroup(_ newGroup: GroupRecord?) {
        record.group = newGroup
        try? modelContext.save()
    }
}
