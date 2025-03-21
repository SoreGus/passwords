//
//  PasswordViewModel.swift
//  Passwords
//
//  Created by Gustavo Soré on 19/03/25.
//


import SwiftUI
import LocalAuthentication
import SwiftData

class PasswordViewModel: ObservableObject {
    @Published var decryptedPassword: String?
    @Published var showPassword = false
    @Published var authenticationError = false
    @Published var selectedFolder: Folder?
    @Published var copied = false
    private let record: Password
    private let storageWorker: SecureStorageWorkerProtocol

    init(
        record: Password,
        storageWorker: SecureStorageWorkerProtocol = SecureStorageWorker()
    ) {
        self.record = record
        self.storageWorker = storageWorker
        self.selectedFolder = record.folder
    }

    var domain: String { record.domain }
    var username: String { record.email }
    var createdAt: String { record.createdAt.formatted(date: .long, time: .shortened) }
    var accessHistory: [Date] { record.accessHistory }

    func authenticateUser() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Authenticate to view the password"

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, _ in
                DispatchQueue.main.async {
                    if success {
                        self.decryptPassword()
                    } else {
                        self.authenticationError = true
                    }
                }
            }
        } else {
            authenticationError = true
        }
    }

    private func decryptPassword() {
        Task {
            do {
                let decriptedPassword = try storageWorker.decryptPassword(record.encryptedPassword)
                DispatchQueue.main.async {
                    self.decryptedPassword = decriptedPassword
                    self.showPassword = true
                }
            } catch {
                print("Decryption error: \(error)")
            }
        }
    }

    func updateGroup(_ newFolder: Folder?, modelContext: ModelContext) {
        record.folder = newFolder
        selectedFolder = newFolder
        try? modelContext.save()
    }

    func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
        copied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.copied = false
        }
    }
}
