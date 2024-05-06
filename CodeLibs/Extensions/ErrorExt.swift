import Foundation


extension NSError {
    static func with(message: String, code: Int? = nil, domain: String? = Bundle.main.bundleIdentifier) -> NSError {
        var userInfo: [String: Any] = [NSLocalizedDescriptionKey: message]
        if let code = code {
            userInfo[NSLocalizedFailureReasonErrorKey] = "Error code: \(code)"
        }
        return NSError(domain: domain ?? "com.unknown", code: code ?? 0, userInfo: userInfo)
    }
}

extension Error {
    func throwError<T>() throws -> T {
        throw self
    }
}

infix operator ?!: NilCoalescingPrecedence
func ?!<T>(value: T?, error: @autoclosure () -> Error) throws -> T {
    guard let value = value else {
        throw error()
    }
    return value
}

