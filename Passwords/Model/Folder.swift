import SwiftData
import Foundation

@Model
class Folder {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var createdAt: Date
    @Relationship(deleteRule: .cascade) var passwords: [Password] = [] // Relação com senhas

    init(name: String) {
        self.name = name
        self.createdAt = Date()
    }
}
