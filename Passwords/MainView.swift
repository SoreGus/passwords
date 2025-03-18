import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var groups: [Group]
    @State private var selectedGroup: Group?
    @State private var selectedPassword: Password?

    var body: some View {
        NavigationSplitView {
            
            VStack {
                NavigationLink(destination: AddPasswordView()
                    .onAppear {
                        selectedGroup = nil
                        selectedPassword = nil
                    }) {
                    Text("New Password")
                        .font(.headline)
                        .frame(maxWidth: .infinity, maxHeight: 10)
                        .padding()
                        .foregroundColor(.blue)
                        .overlay(
                            Capsule()
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }
                .listRowBackground(Color.clear)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)

                List(groups, selection: $selectedGroup) { group in
                    Text(group.name)
                        .onTapGesture {
                            selectedGroup = group
                            selectedPassword = nil
                        }
                }
                .navigationTitle("Groups")
                .toolbar {
                    ToolbarItem {
                        NavigationLink(destination: AddGroupView()
                            .onAppear {
                                selectedGroup = nil
                                selectedPassword = nil
                            }) {
                            Text("New Group")
                        }
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 5)
                    }
                }
            }
        } content: {
            if let selectedGroup = selectedGroup {
                let passwords = Group.fetchGroup(modelContext, groupID: selectedGroup.id)
                List(passwords, selection: $selectedPassword) { password in
                    Text(password.domain)
                        .onTapGesture {
                            selectedPassword = password
                        }
                }
                .navigationTitle("Passwords")
            } else {
                Text("Select Group")
            }
        } detail: {
            if let selectedPassword = selectedPassword {
                PasswordRegisterView(record: selectedPassword)
            } else {
                Text("Select a password to view details")
                    .foregroundColor(.gray)
            }
        }
    }
}
