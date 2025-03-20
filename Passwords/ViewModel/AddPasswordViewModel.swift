import SwiftUI
import SwiftData

class AddPasswordViewModel: ObservableObject {
    
    @Published var domain = ""
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var selectedFolder: Folder?
    @Published var folders: [Folder] = []
    
    init(
        context: ModelContext,
        selectedfolder: Folder?
    ) {
        self.selectedFolder = selectedfolder
        fetchFolders(context)
    }
    
    func fetchFolders(_ context: ModelContext) {
        let descriptor = FetchDescriptor<Folder>()
        do {
            folders = try context.fetch(descriptor)
            print("Pastas carregadas na init: \(folders.map { $0.name })")
        } catch {
            print("Erro ao buscar pastas: \(error)")
        }
    }
    
    func savePassword(_ context: ModelContext) {
        Task {
            let encryptedPassword = Data(count: 256)
            let newRecord = Password(domain: domain, email: email, username: username, encryptedPassword: encryptedPassword, folder: selectedFolder)
            
            context.insert(newRecord)
            try? context.save()
        }
    }
}
