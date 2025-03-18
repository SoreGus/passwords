import SwiftUI
import SwiftData

struct AddPasswordView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var domain = ""
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @Query(sort: \Group.createdAt, order: .reverse) private var groups: [Group]
    @State private var selectedGroup: Group?
    
    var body: some View {
        Form {
            Section("Details") {
                TextField("Domain", text: $domain)
                TextField("User / Email", text: $email)
                SecureField("Password", text: $password)
            }
            
            Section("Group") {
                Picker("Select Group", selection: $selectedGroup) {
                    Text("No Group").tag(nil as Group?)
                    ForEach(groups) { group in
                        Text(group.name).tag(group as Group?)
                    }
                }
            }
            
            Button("Save") {
                Task {
                   // do {
                     //   let encryptedPassword = try await SecureStorageWorker.shared.encryptPassword(password)
                        let newRecord = Password(domain: domain, email: email, username: username, encryptedPassword: .init(count: 256), group: selectedGroup)
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
