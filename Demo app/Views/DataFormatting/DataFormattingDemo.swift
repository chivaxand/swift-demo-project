import SwiftUI

struct DataFormattingDemo: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Button("Int") {
                    intFormatting()
                }
                
                Button("Float") {
                    floatFormatting()
                }
                
                Button("NumberFormatter") {
                    withNumberFormatter()
                }
                
                Button("Other types") {
                    otherTypesFormatting()
                }
                
                Button("Date and Time") {
                    dateTimeFormatting()
                }
                
                Button("Byte Size Formatting") {
                    byteSizeFormatting()
                }
            }
            .padding(.top, 20)
            Spacer()
        }
    }
    
    func intFormatting() {
        let int8: Int8 = -128
        let int16: Int16 = -32768
        let int32: Int32 = -2147483648
        let int64: Int64 = -9223372036854775808
        let int: Int = -9223372036854775808
        NSLog("Int8: %hhd", int8)
        NSLog("Int16: %hd", int16)
        NSLog("Int32: %d", int32)
        NSLog("Int32: %i", int32)
        NSLog("Int64: %lld", int64)
        NSLog("Int: %lld", int)
        
        let uint8: UInt8 = 255
        let uint16: UInt16 = 65535
        let uint32: UInt32 = 4294967295
        let uint64: UInt64 = 18446744073709551615
        let uint: UInt = 18446744073709551615
        NSLog("UInt8: %hhu", uint8)
        NSLog("UInt16: %hu", uint16)
        NSLog("UInt32: %u", uint32)
        NSLog("UInt64: %llu", uint64)
        NSLog("UInt: %llu", uint)
        
        let hexValue = uint32
        NSLog("Hex: %x, %X", hexValue, hexValue)
        NSLog("Octal: %o", hexValue)
        NSLog("Percentage symbol: %%")
        NSLog("Nothing: `%n`")
    }
    
    func floatFormatting() {
        let float: Float = 1234.56789
        let double: Double = 1234.56789
        NSLog("Float: %f, %lf, %Lf", float, double, double)
        NSLog("Scientific: %e, %E", float, float)
        NSLog("Float with 2 decimal: %.2f, %.2lf", float, double)
        NSLog("Float with current precision: %g, %G", float, double)
    }
    
    func withNumberFormatter() {
        let number = NSNumber(value: 1234567.8912345)
        let frm = NumberFormatter()
        frm.numberStyle = .decimal
        frm.usesGroupingSeparator = true
        frm.groupingSeparator = "`"
        frm.groupingSize = 3
        frm.secondaryGroupingSize = 2
        frm.minimumFractionDigits = 0
        frm.maximumFractionDigits = 2
        frm.decimalSeparator = "."
        frm.locale = Locale(identifier: "en_US")
        
        if let formattedString = frm.string(from: number) {
            NSLog("Formatted: %@", formattedString)
        }
    }
    
    func otherTypesFormatting() {
        /*
        let char: Character = "A"
        let string = "Hello, Swift!".utf8CString
        let pointer: UnsafeMutableRawPointer = UnsafeMutableRawPointer(bitPattern: 0x7fff5fbff61d)!
        NSLog("string: %s", string)
        NSLog("char: %c", char)
        NSLog("pointer: %p", pointer)
        */
    }
    
    func dateTimeFormatting() {
        let date = Date()
        let frm = DateFormatter()
        frm.dateFormat = "yyyy-MM-dd HH:mm:ss"
        NSLog("Formatted time: %@", frm.string(from: date))
        
        // ISO 8601
        let iso8601Formatter1 = DateFormatter()
        iso8601Formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        NSLog("ISO 8601: %@", iso8601Formatter1.string(from: date))
        let iso8601Formatter2 = ISO8601DateFormatter()
        iso8601Formatter2.formatOptions = [.withInternetDateTime]
        NSLog("ISO 8601: %@", iso8601Formatter2.string(from: date))
        
        // Formatting using locale
        let localFormatter = DateFormatter()
        localFormatter.locale = Locale(identifier: "en_US")
        localFormatter.dateStyle = .short
        localFormatter.timeStyle = .short
        NSLog("US: %@", localFormatter.string(from: date))
        localFormatter.locale = Locale(identifier: "fr_FR")
        NSLog("FR: %@", localFormatter.string(from: date))
        localFormatter.locale = Locale(identifier: "ja_JP")
        NSLog("JP: %@", localFormatter.string(from: date))
    }
    
    func byteSizeFormatting() {
        let byteSize: UInt64 = 15 * 1024 * 1024 + 20 * 1024
        let frm = ByteCountFormatter()
        frm.allowedUnits = [.useAll]
        frm.includesActualByteCount = true
        frm.countStyle = .binary
        let formattedSize = frm.string(fromByteCount: Int64(byteSize))
        NSLog("Byte Size: %@", formattedSize)
    }
}

#Preview {
    DataFormattingDemo()
}
