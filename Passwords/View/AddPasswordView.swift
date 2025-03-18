import SwiftUI
import SwiftData

struct AddPasswordView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var domain = ""
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @Query(sort: \GroupRecord.createdAt, order: .reverse) private var groups: [GroupRecord]
    @State private var selectedGroup: GroupRecord?
    
    var body: some View {
        Form {
            Section("Details") {
                TextField("Domain", text: $domain)
                TextField("Email", text: $email)
                TextField("Username", text: $username)
                SecureField("Password", text: $password)
            }
            
            Section("Group") {
                Picker("Select Group", selection: $selectedGroup) {
                    Text("No Group").tag(nil as GroupRecord?)
                    ForEach(groups) { group in
                        Text(group.name).tag(group as GroupRecord?)
                    }
                }
            }
            
            Button("Save") {
                Task {
                   // do {
                     //   let encryptedPassword = try await SecureStorageWorker.shared.encryptPassword(password)
                        let newRecord = PasswordRecord(domain: domain, email: email, username: username, encryptedPassword: .init(count: 256), group: selectedGroup)
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
