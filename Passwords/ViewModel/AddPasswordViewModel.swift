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
    @Published var domainError: String?
    @Published var emailError: String?
    @Published var passwordError: String?
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
            print("Folders loaded in init: \(folders.map { $0.name })")
        } catch {
            print("Error fetching folders: \(error)")
        }
    }
    
    func validateFields() -> Bool {
        var isValid = true
        
        if domain.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            domainError = "Domain cannot be empty."
            isValid = false
        } else {
            domainError = nil
        }
        
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            emailError = "Email cannot be empty."
            isValid = false
        } else if !isValidEmail(email) {
            emailError = "Invalid email format."
            isValid = false
        } else {
            emailError = nil
        }
        
        if password.isEmpty {
            passwordError = "Password cannot be empty."
            isValid = false
        } else {
            passwordError = nil
        }
        
        return isValid
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func savePassword(_ context: ModelContext) {
        guard validateFields() else { return }
        
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
