import Foundation
import OSLog

/*
 private let logger = Logger.init(name: SomeClass.self)
 logger.error("Error text")
 */
public class Logger {
    
    var dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss.SSSS" // "yyyy-MM-dd H:mm:ss.SSSS"
        return dateFormatter
    }()
    
    public enum LogLevel : Int {
        case disabled, debug, info, warning, error
    }
    
    public let name : NSString
    public let logLevel : LogLevel
    private var osLogger: Any? = nil
    
    required init(name: Any, logLevel: LogLevel = .info) {
        self.name = (name as? NSString) ?? ((name is Any.Type) ? "\(name)" : "\(type(of: name))") as NSString
        self.logLevel = logLevel
    }
    
    public func debug(_ msg: String?) {
        log(level: .debug, msg: msg)
    }
    
    public func info(_ msg: String?) {
        log(level: .info, msg: msg)
    }
    
    public func warning(_ msg: String?) {
        log(level: .warning, msg: msg)
    }
    
    public func error(_ msg: String?) {
        log(level: .error, msg: msg)
    }
    
    public func log(level: LogLevel, msg: String?) {
        if (level.rawValue < logLevel.rawValue) {
            return
        }
        let currentDateTime = self.dateFormatter.string(from: Date())
        let message = "\(currentDateTime) \(name): \(msg ?? "")"
        
        if #available(iOS 14.0, *) {
            if self.osLogger as? os.Logger == nil {
                self.osLogger = os.Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.app", category: self.name as String)
            }
            guard let logger = self.osLogger as? os.Logger else {
                return
            }
            
            switch level {
            case .disabled:
                return
            case .debug:
                logger.info("\(message)")
            case .info:
                logger.info("\(message)")
            case .warning:
                logger.warning("\(message)")
            case .error:
                logger.critical("\(message)")
            }
        } else {
            print(message)
        }
    }
    
}
