import Foundation
import Security

class KeychainHelper {
    
    enum KeychainError: String, CustomNSError {
        case unableToSave = "Unable to save to keychain"
        case unableToUpdate = "Unable to update keychain value"
        case unableToLoad = "Unable to load from keychain"
        case unableToDelete = "Unable to delete from keychain"
        var localizedDescription: String { self.rawValue }
    }
    
    // MARK: - Public Methods

    static func save(data: Data, forKey key: String) throws {
        let status = update(data: data, forKey: key)
        if status == errSecItemNotFound {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw KeychainError.unableToSave
            }
        } else if status != errSecSuccess {
            throw KeychainError.unableToSave
        }
    }
    
    static private func update(data: Data, forKey key: String) -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        let attributesToUpdate: [String: Any] = [
            kSecValueData as String: data
        ]
        return SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
    }
    
    static func load(forKey key: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return data
            } else {
                throw KeychainError.unableToLoad
            }
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw KeychainError.unableToLoad
        }
    }
    
    static func delete(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            throw KeychainError.unableToDelete
        }
    }
}
