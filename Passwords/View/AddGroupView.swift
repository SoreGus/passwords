import SwiftUI
import SwiftData

struct AddGroupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var groupName = ""
    
    var body: some View {
        Form {
            Section("Group Name") {
                TextField("Enter group name", text: $groupName)
            }
            
            Button("Save") {
                saveGroup()
            }
            .disabled(groupName.isEmpty)
        }
        .navigationTitle("New Group")
    }
    
    private func saveGroup() {
        let newGroup = GroupRecord(name: groupName)
        modelContext.insert(newGroup)
        try? modelContext.save()
        dismiss()
    }
}
