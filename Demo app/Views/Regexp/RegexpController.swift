import SwiftUI

struct RegexpController: View {
    var body: some View {
        List {
            Button("First match") {
                let input = "testName123"
                do {
                    let regex = try Regex(#"([a-zA-Z]+)([0-9]+)"#)
                    if let match = try regex.firstMatch(in: input) {
                        if let lettersRange = match[1].range,
                           let digitsRange = match[2].range {
                            print("Letters: \(input[lettersRange]), digits: \(input[digitsRange])")
                        }
                    } else {
                        print("No match found")
                    }
                } catch {
                    print("Error compiling regex: \(error)")
                }
            }
            
            Button("Regex literal") {
                let input = "testName123"
                do {
                    let regex = /([a-zA-Z]+)([0-9]+)/
                    if let match = try regex.firstMatch(in: input) {
                        print("Letters: \(match.1), digits: \(match.2)")
                    } else {
                        print("No match found")
                    }
                } catch {
                    print("Error compiling regex: \(error)")
                }
            }
            
            Button("Regex with names") {
                let email = "username@example.com"
                let regex = /(?<username>[a-zA-Z0-9._%+-]+)@(?<domain>[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})/
                do {
                    if let match = try regex.wholeMatch(in: email) {
                        print("Username: \(match.username), domain: \(match.domain)")
                    } else {
                        print("No match found")
                    }
                } catch {
                    print("Regex error: \(error)")
                }
            }
            
            Button("All matches with groups") {
                let input = "aa11_bb22"
                let pattern = "([a-zA-Z]+)([0-9]+)"
                let matches = getAllMatchesWithGroups(pattern: pattern,
                                                      string: input)
                print("Matches:")
                for groups in matches {
                    print("groups: \(groups)")
                }
            }
            
            Button("All matches") {
                let matches = allMatches(pattern: #"([a-zA-Z]+)([0-9]+)"#, in: "aa11-bb22")
                print("Matches: \(matches)")
            }
        }
    }
    
    func getAllMatchesWithGroups(pattern: String, string: String) -> [[String]] {
        var results: [[String]] = []
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: string,
                                        range: NSRange(string.startIndex..., in: string))
            for match in matches {
                var groupMatches: [String] = []
                for i in 0..<match.numberOfRanges {
                    let range = Range(match.range(at: i), in: string)!
                    groupMatches.append(String(string[range]))
                }
                results.append(groupMatches)
            }
        } catch {
            print("Regex error: \(error)")
        }
        return results
    }
    
    func allMatches(pattern: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let results = regex.matches(in: text, options: [], range: NSRange(text.startIndex..., in: text))
            return results.map { String(text[Range($0.range, in: text)!]) }
        } catch let error {
            print("Regex error: \(error.localizedDescription)")
            return []
        }
    }
}

#Preview {
    RegexpController()
}
