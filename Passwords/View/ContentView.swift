import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var passwordRecords: [PasswordRecord]
    @Query private var groups: [GroupRecord]
    
    @State private var searchText = ""
    @State private var expandedGroups: Set<UUID> = []
    @State private var isDeleteMode = false
    @State private var showDeleteConfirmation = false
    @State private var groupToDelete: GroupRecord?
    @State private var navigateToAddGroup = false  // Controla a navegação para adicionar grupo
    
    var filteredRecords: [PasswordRecord] {
        if searchText.isEmpty {
            return passwordRecords
        }
        return passwordRecords.filter { $0.domain.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            
            List {
                NavigationLink(destination: AddPasswordView()) {
                    Text("New Password")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.blue)
                        .overlay(
                            Capsule()
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }
                .listRowBackground(Color.clear)
                .padding(.vertical, 5)
        
                ForEach(groups) { group in
                    let isExpanded = expandedGroups.contains(group.id)
                    
                    Section(header: GroupHeaderView(group: group, expandedGroups: $expandedGroups, isDeleteMode: isDeleteMode, deleteGroupAction: confirmDeleteGroup)) {
                        if isExpanded {
                            ForEach(filteredRecords.filter { $0.group?.id == group.id }) { record in
                                NavigationLink(destination: PasswordRegisterView(record: record)) {
                                    PasswordRowView(record: record, isExpanded: isExpanded)
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        deletePassword(record)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                            .transition(.opacity)
                        }
                    }
                    .listRowBackground(isExpanded ? Color.blue.opacity(0.15) : Color.clear)
                    .animation(.easeInOut(duration: 0.25), value: isExpanded)
                }
                if !filteredRecords.filter({ $0.group == nil }).isEmpty {
                    Section(header: Text("No Group")) {
                        ForEach(filteredRecords.filter { $0.group == nil }) { record in
                            NavigationLink(destination: PasswordRegisterView(record: record)) {
                                PasswordRowView(record: record, isExpanded: false)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    deletePassword(record)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                
            }
            .searchable(text: $searchText)
            .navigationTitle("Passwords")
            .toolbar {
                ToolbarItem {
                    NavigationLink(destination: AddGroupView()) {
                        Text("New Group")
                    }
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 5)
                }
            }
            .alert("Delete Group?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let group = groupToDelete {
                        deleteGroup(group)
                    }
                }
            } message: {
                Text("Are you sure you want to delete this group? All associated passwords will be moved to 'No Group'.")
            }
        }
    }
    
    private func deletePassword(_ record: PasswordRecord) {
        modelContext.delete(record)
    }
    
    private func confirmDeleteGroup(_ group: GroupRecord) {
        groupToDelete = group
        showDeleteConfirmation = true
    }
    
    private func deleteGroup(_ group: GroupRecord) {
        for record in passwordRecords where record.group?.id == group.id {
            record.group = nil
        }
        modelContext.delete(group)
        try? modelContext.save()
    }
}
