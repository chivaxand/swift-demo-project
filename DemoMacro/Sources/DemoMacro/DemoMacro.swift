
// #stringify(x + y)
// `(x + y, "x + y")`
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "DemoMacroMacros", type: "StringifyMacro")


@attached(member, names: arbitrary)
public macro KeyValueProperties() = #externalMacro(module: "DemoMacroMacros", type: "KeyValuePropertiesMacro")
