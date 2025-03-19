import SwiftUI
import SwiftData

struct AddGroupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var folderName = ""
    
    var body: some View {
        Form {
            Section("Folder Name") {
                TextField("Enter folder name", text: $folderName)
            }
            
            Button("Save") {
                saveGroup()
            }
            .disabled(folderName.isEmpty)
        }
        .navigationTitle("New Folder")
    }
    
    private func saveGroup() {
        let newFolder = Folder(name: folderName)
        modelContext.insert(newFolder)
        try? modelContext.save()
        dismiss()
    }
}
