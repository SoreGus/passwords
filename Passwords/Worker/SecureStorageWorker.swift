import Foundation
import Security
import CryptoKit

actor SecureStorageWorker {
    static let shared = SecureStorageWorker()
    private let keyTag = "com.myapp.securekey"
    
    private init() {}
    
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
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: keyTag
            ]
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
