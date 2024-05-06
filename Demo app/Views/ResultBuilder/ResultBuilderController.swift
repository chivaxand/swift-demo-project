import SwiftUI

struct ResultBuilderController: View {
    
    var body: some View {
        List {
            Button("Build") {
                let directory = Directory(name: "root") {
                    FileItem(name: "README.txt")
                    "index.html"
                    Directory(name: "css") {
                        FileItem(name: "styles.css")
                    }
                    dir(name: "static") {
                        FileItem(name: "admin.html")
                    }
                }
                print(directory)
            }
        }
    }
    
    @resultBuilder
    enum FileSystemBuilder {
        static func buildBlock(_ components: FileSystemObject...) -> [FileSystemObject] {
            components.compactMap { $0 }
        }
        static func buildArray(_ components: [[FileSystemObject]]) -> [FileSystemObject] {
            return components.flatMap { $0 }
        }
        static func buildExpression(_ item: FileSystemObject) -> FileSystemObject {
            return item
        }
        static func buildExpression(_ fileName: String) -> FileSystemObject {
            return FileItem(name: fileName)
        }
//        static func buildPartialBlock(first: [FileSystemObject]) -> [FileSystemObject] {
//            return first
//        }
//        static func buildPartialBlock(accumulated: [FileSystemObject], next: [FileSystemObject]) -> [FileSystemObject] {
//            return nil
//        }
//        static func buildFinalResult(_ component: [FileSystemObject]) -> [FileSystemObject] {
//            return component
//        }
    }
    
    class FileSystemObject: CustomStringConvertible {
        var description: String {
            return "unknown"
        }
        let name: String
        init(name: String) {
            self.name = name
        }
    }
    
    class FileItem: FileSystemObject {
        override var description: String {
            return "file: `\(name)`"
        }
    }
    
    class Directory: FileSystemObject {
        override var description: String {
            return "dir: `\(name)`"
        }
        let contents: [FileSystemObject]
        init(name: String, @FileSystemBuilder contents: () -> [FileSystemObject]) {
            self.contents = contents()
            super.init(name: name)
        }
    }
    
    func dir(name: String, @FileSystemBuilder contents: () -> [FileSystemObject]) -> Directory {
        return Directory(name: name, contents: contents)
    }
    
}
