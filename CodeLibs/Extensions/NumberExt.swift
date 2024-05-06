import Foundation


extension FixedWidthInteger {
    var toNSNumber: NSNumber {
        return NSNumber(value: Int64(self))
    }
    var toString: String {
        return String(Int64(self))
    }
}


extension BinaryFloatingPoint {
    func getProgress(from minValue: Self, to maxValue: Self) -> CGFloat {
        guard minValue != maxValue else {
            return 0
        }
        
        let range = (maxValue - minValue)
        let limitedValue = min(max(self, minValue), maxValue)
        return Double(limitedValue - minValue) / Double(range)
    }
}

