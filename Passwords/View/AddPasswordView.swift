import SwiftUI
import SwiftData

struct AddPasswordView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var domain = ""
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @Query(sort: \Folder.createdAt, order: .reverse) private var folders: [Folder]
    @State private var selectedFolder: Folder?
    
    var body: some View {
        Form {
            Section("Details") {
                TextField("Domain", text: $domain)
                TextField("User / Email", text: $email)
                SecureField("Password", text: $password)
            }
            
            Section("Group") {
                Picker("Select Group", selection: $selectedFolder) {
                    Text("No Group").tag(nil as Folder?)
                    ForEach(folders) { folder in
                        Text(folder.name).tag(folder as Folder?)
                    }
                }
            }
            
            Button("Save") {
                Task {
                   // do {
                     //   let encryptedPassword = try await SecureStorageWorker.shared.encryptPassword(password)
                        let newRecord = Password(domain: domain, email: email, username: username, encryptedPassword: .init(count: 256), folder: selectedFolder)
                        modelContext.insert(newRecord)
                        dismiss()
//                    } catch {
//                        print("Encryption error: \(error)")
//                    }
                }
            }
        }
        .navigationTitle("New Password")
    }
}
