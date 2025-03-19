import SwiftUI
import SwiftData

struct AddFolderView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModel: AddFolderViewModel
    @State private var folderName = ""

    var body: some View {
        Form {
            Section() {
                TextField("Folder Name", text: $folderName)

                Button("Save") {
                    viewModel.save(folderName: folderName, context: modelContext)
                    folderName = ""
                }
            }
        }
        .navigationTitle("New Folder")
        .padding()
    }
}

#Preview {
    AddFolderView(viewModel: .init())
        .environment(\.colorScheme, .dark)
}
