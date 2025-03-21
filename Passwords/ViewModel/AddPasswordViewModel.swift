import SwiftUI
import SwiftData

class AddPasswordViewModel: ObservableObject {
    
    @Published var domain = ""
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var selectedFolder: Folder?
    @Published var folders: [Folder] = []
    private let storageWorker: SecureStorageWorkerProtocol
    
    init(
        context: ModelContext,
        selectedfolder: Folder?,
        storageWorker: SecureStorageWorkerProtocol = SecureStorageWorker()
    ) {
        self.selectedFolder = selectedfolder
        self.storageWorker = storageWorker
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
            do {
                let encripted = try storageWorker.encryptPassword(password)
                let newRecord = Password(domain: domain, email: email, username: username, encryptedPassword: encripted, folder: selectedFolder)
                
                context.insert(newRecord)
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}
