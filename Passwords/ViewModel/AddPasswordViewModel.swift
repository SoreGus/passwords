import SwiftUI
import SwiftData

class AddPasswordViewModel: ObservableObject {
    
    @Published var domain = ""
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var selectedFolder: Folder?
    @Binding var selectedPassword: Password?
    @Binding var createNewPassword: Bool
    @Published var folders: [Folder] = []
    private let storageWorker: SecureStorageWorkerProtocol
    
    init(
        context: ModelContext,
        selectedfolder: Folder?,
        selectedPassword: Binding<Password?>,
        createNewPassword: Binding<Bool>,
        storageWorker: SecureStorageWorkerProtocol = SecureStorageWorker()
    ) {
        self.selectedFolder = selectedfolder
        self.storageWorker = storageWorker
        self._createNewPassword = createNewPassword
        self._selectedPassword = selectedPassword
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
                let newPassword = Password(domain: domain, email: email, username: username, encryptedPassword: encripted, folder: selectedFolder)
                
                context.insert(newPassword)
                try context.save()
                DispatchQueue.main.async {
                    self.selectedPassword = newPassword
                    self.createNewPassword = false
                }
            } catch {
                print(error)
            }
        }
    }
}
