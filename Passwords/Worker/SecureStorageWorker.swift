import Foundation
import Security
import CryptoKit

protocol SecureStorageWorkerProtocol {
    func encryptPassword(_ password: String) throws -> Data
    func decryptPassword(_ encryptedData: Data) throws -> String
}

class SecureStorageWorker: SecureStorageWorkerProtocol {
    static let shared = SecureStorageWorker()
    private let keyTag = "sore.passwords.key"
    
    public init() {}
    
    private func getSecureKey() throws -> SecKey {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyTag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecReturnRef as String: true
        ]
        
        var keyRef: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &keyRef)
        
        if status == errSecSuccess, let key = keyRef as! SecKey? {
            return key
        }
        
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String: 256,
            kSecAttrIsPermanent as String: true,  // Apenas para chaves privadas
            kSecAttrApplicationTag as String: keyTag,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
            kSecAttrAccessGroup as String: "Z33726G6B5.sore.passwords"
        ]
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }

        return privateKey
    }
    
    func encryptPassword(_ password: String) throws -> Data {
        let key = try getSecureKey()
        guard let passwordData = password.data(using: .utf8) else {
            throw NSError(domain: "Invalid password encoding", code: -1, userInfo: nil)
        }
        
        var error: Unmanaged<CFError>?
        guard let encryptedData = SecKeyCreateEncryptedData(
            key, .eciesEncryptionStandardX963SHA256AESGCM, passwordData as CFData, &error) as Data? else {
            throw error!.takeRetainedValue() as Error
        }
        
        return encryptedData
    }
    
    func decryptPassword(_ encryptedData: Data) throws -> String {
        let key = try getSecureKey()
        
        var error: Unmanaged<CFError>?
        guard let decryptedData = SecKeyCreateDecryptedData(
            key, .eciesEncryptionStandardX963SHA256AESGCM, encryptedData as CFData, &error) as Data? else {
            throw error!.takeRetainedValue() as Error
        }
        
        return String(decoding: decryptedData, as: UTF8.self)
    }
}
