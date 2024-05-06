import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

// https://github.com/apple/swift-syntax/blob/main/Examples/Sources/MacroExamples/Implementation/Member/CustomCodable.swift

public enum KeyValuePropertiesMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let properties = try getPropertiesInfo(declaration)
        
        var casesList: String = ""
        let propertiesSorted = properties.values.sorted { $0.index < $1.index }
        for property in propertiesSorted {
            casesList += generateSwitchCase(for: property)
        }
        
        let codingKeys: DeclSyntax = """
        func _setValue(_ value: Any?, forKey key: String) {
            switch key {
            \(raw: casesList)
            default:
                break
            }
        }
        """
        return [codingKeys]
    }
    
    private static func generateSwitchCase(for property: PropertyInfo) -> String {
        var caseString = "case \"\(property.name)\":\n"
        if property.readOnly {
            caseString += "break // read only\n"
            return caseString
        }
        if property.nullable {
            caseString += "self.\(property.name) = value as? \(property.typeNonOptional)\n"
        } else {
            caseString += "if let value = value as? \(property.typeNonOptional) {\n"
            caseString += "self.\(property.name) = value\n"
            caseString += "}\n"
        }
        return caseString
    }
}


struct PropertyInfo {
    let index: Int
    let name: String
    let type: String
    let typeNonOptional: String
    let readOnly: Bool
    let nullable: Bool
}

func getPropertiesInfo(_ declaration: DeclGroupSyntax) throws -> [String: PropertyInfo] {
    let members = declaration.memberBlock.members
    var infoDict = [String: PropertyInfo]()
    for (index, member) in members.enumerated() {
        guard let variableDecl = member.decl.as(VariableDeclSyntax.self),
              let propertyName = variableDecl.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
              let typeAnnotation = variableDecl.bindings.first?.typeAnnotation
        else {
            continue // not a property
        }

        let propertyType = typeAnnotation.type.description
        let readOnly = variableDecl.bindingSpecifier.text == "let"
        let nullable = propertyType.hasSuffix("?")
        let typeNonOptional = nullable ? String(propertyType.dropLast()) : propertyType
        
        infoDict[propertyName] = PropertyInfo(
            index: index,
            name: propertyName,
            type: propertyType,
            typeNonOptional: typeNonOptional,
            readOnly: readOnly,
            nullable: nullable
        )
    }
    return infoDict
}

// throw NSError(domain: "X", code: 1, userInfo: [NSLocalizedDescriptionKey: "bug: \(aaa)"])

extension TokenSyntax {
  fileprivate var initialUppercased: String {
    let name = self.text
    guard let initial = name.first else {
      return name
    }

    return "\(initial.uppercased())\(name.dropFirst())"
  }
}
