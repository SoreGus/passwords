import SwiftData
import Foundation

@Model
class PasswordRecord: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var domain: String
    var email: String
    var username: String
    var encryptedPassword: Data
    var createdAt: Date
    var accessHistory: [Date]
    var group: GroupRecord?
    
    init(domain: String, email: String, username: String, encryptedPassword: Data, group: GroupRecord?) {
        self.domain = domain
        self.email = email
        self.username = username
        self.encryptedPassword = encryptedPassword
        self.createdAt = Date()
        self.accessHistory = []
        self.group = group
    }
}
