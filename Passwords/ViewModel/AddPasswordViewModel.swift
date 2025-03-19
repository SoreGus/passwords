import SwiftUI
import SwiftData

class AddPasswordViewModel: ObservableObject {
    
    @Published var domain = ""
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var selectedFolder: Folder?
    @Published var folders: [Folder] = []
    
    func fetchFolders(_ context: ModelContext) {
        let descriptor = FetchDescriptor<Folder>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        folders = (try? context.fetch(descriptor)) ?? []
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
