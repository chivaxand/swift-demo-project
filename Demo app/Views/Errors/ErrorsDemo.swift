import SwiftUI

struct ErrorsDemo: View {
    var body: some View {
        ScrollView {
            VStack {
                Button("Test1") {
                    do {
                        var data = try getData() ?! DemoError.aaa
                        data = try getData() ?? { throw DemoError2.aaa }()
                        data = try getData() ?? URLError(.badURL).throwError()
                        print("Result: \(data)")
                    } catch {
                        let error = error as NSError
                        print("Error: \(error.domain), \(error.code), \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func getData() -> String? {
        // let data = try? JSONEncoder().encode("test")
        return nil
    }
}

enum DemoError: String, CustomNSError {
    case aaa = "error AAA"
    case bbb = "error BBB"
    case ccc = "error CCC"
    
    var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey: self.rawValue]
    }
    
    var errorCode: Int {
        switch self {
        case .aaa:
            return 111
        case .bbb:
            return 222
        case .ccc:
            return 333
        }
    }
}

enum DemoError2: String, CustomNSError {
    case aaa
    case bbb
    case ccc
    
    func getInfo() -> (code: Int, message: String) {
        switch self {
        case .aaa: return (111, "error AAA")
        case .bbb: return (222, "error BBB")
        case .ccc: return (333, "error CCC")
        }
    }
    var errorUserInfo: [String : Any] { [NSLocalizedDescriptionKey: getInfo().message] }
    var errorCode: Int { getInfo().code }
}



#Preview {
    ErrorsDemo()
}
