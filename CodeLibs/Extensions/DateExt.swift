import Foundation

extension Date {
    var timestampMsec : UInt64 {
        return UInt64(self.timeIntervalSince1970 * 1000)
    }
    
    init(msec: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(msec) / 1000)
    }
}
