import Foundation


extension Data {
    func decodeJson<T: Decodable>(
        as type: T.Type,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    ) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: self)
        } catch DecodingError.keyNotFound(let key, let context) {
            let errorDescription = "Missing key '\(key.stringValue)' – \(context.debugDescription)"
            throw NSError(domain: "DecodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])
        } catch DecodingError.typeMismatch(_, let context) {
            let errorDescription = "Type mismatch – \(context.debugDescription)"
            throw NSError(domain: "DecodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])
        } catch DecodingError.valueNotFound(let type, let context) {
            let errorDescription = "Missing \(type) value – \(context.debugDescription)"
            throw NSError(domain: "DecodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])
        } catch DecodingError.dataCorrupted(_) {
            let errorDescription = "Invalid JSON."
            throw NSError(domain: "DecodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])
        } catch {
            let errorDescription = "Failed to decode data: \(error.localizedDescription)"
            throw NSError(domain: "DecodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: errorDescription])
        }
    }
}
