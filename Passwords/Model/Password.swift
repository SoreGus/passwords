import SwiftData
import Foundation

@Model
class Password {
    @Attribute(.unique) var id: UUID = UUID()
    var domain: String
    var email: String
    var username: String
    var encryptedPassword: Data
    var createdAt: Date
    @Transient var accessHistory: [Date] = [] // Array não é diretamente suportado pelo SwiftData
    @Relationship(inverse: \Folder.passwords) var folder: Folder? // Relacionamento com Folder

    init(domain: String, email: String, username: String, encryptedPassword: Data, folder: Folder?) {
        self.domain = domain
        self.email = email
        self.username = username
        self.encryptedPassword = encryptedPassword
        self.createdAt = Date()
        self.folder = folder
    }
}
