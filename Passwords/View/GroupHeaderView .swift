import SwiftUI

struct GroupHeaderView: View {
    let group: GroupRecord
    @Binding var expandedGroups: Set<UUID>
    var isDeleteMode: Bool
    var deleteGroupAction: (GroupRecord) -> Void
    
    @Environment(\.modelContext) private var modelContext
    
    var isExpanded: Bool {
        expandedGroups.contains(group.id)
    }
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                toggleExpansion()
            }
        } label: {
            HStack {
                Text(group.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text("\(fetchPasswordCount()) passwords")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if isDeleteMode {
                    Button(role: .destructive) {
                        deleteGroupAction(group)
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .foregroundColor(.red)
                    }
                    .padding(.leading, 5)
                }
            }
            .padding(.vertical, 8)
            .background(isExpanded ? Color.blue.opacity(0.15) : Color.clear)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func fetchPasswordCount() -> Int {
        let passwords = GroupRecord.fetchGroup(modelContext, groupID: group.id)
        return passwords.count
    }
    
    private func toggleExpansion() {
        if isExpanded {
            expandedGroups.remove(group.id)
        } else {
            expandedGroups.insert(group.id)
        }
    }
}
