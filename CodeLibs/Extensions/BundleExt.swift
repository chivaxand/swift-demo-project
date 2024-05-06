import Foundation


extension Bundle {
    func data(forFile fileName: String) throws -> Data {
        guard let url = self.url(forResource: fileName, withExtension: nil) else {
            throw NSError(domain: "BundleError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to locate \(fileName) in bundle."])
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            throw NSError(domain: "BundleError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load \(fileName) from bundle: \(error.localizedDescription)"])
        }
    }
}
