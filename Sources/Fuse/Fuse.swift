#if arch(wasm32)
    import JavaScriptKit
#endif

public func launch<C>(app: C) where C: Component {
    #if arch(wasm32)
        let document = JSObject.global.document
        let element = app.render()
        document.body.append(element)
    #else
        print(app.render())
    #endif
}

@resultBuilder
public struct ComponentBuilder {
    public static func buildBlock<C: Component>(_ c: C) -> C {
        c
    }

    public static func buildPartialBlock<C: Component>(first: C) -> C {
        first
    }

    public static func buildPartialBlock<C1: Component, C2: Component>(accumulated: C1, next: C2) -> tuple<C1, C2> {
        tuple(accumulated, next)
    }
}

public protocol Component {
    associatedtype Body: Component
    var body: Body { get }

    #if arch(wasm32)
        func render() -> JSValue
    #else
        func render() -> String
    #endif
}

public struct tuple<C1, C2>: Component where C1: Component, C2: Component {
    let first: C1
    let second: C2

    public var body: some Component {
        // TODO: Is this okay?
        tuple(first, second)
    }

    public init(_ first: C1, _ second: C2) {
        self.first = first
        self.second = second
    }

    #if arch(wasm32)
        public func render() -> JSValue {
            let document = JSObject.global.document
            let fragment = document.createDocumentFragment()
            fragment.append(first.render())
            fragment.append(second.render())
            return fragment
        }
    #else
        public func render() -> String {
            first.render() + second.render()
        }
    #endif
}

public struct text: Component {
    let content: String

    public var body: some Component {
        text("")
    }

    public init(_ content: String) {
        self.content = content
    }

    #if arch(wasm32)
        public func render() -> JSValue {
            content.jsValue
        }
    #else
        public func render() -> String {
            content
        }
    #endif
}

public struct div<C: Component>: Component {
    let content: C

    public var body: some Component {
        content
    }

    public init(@ComponentBuilder content: () -> C) {
        self.content = content()
    }

    #if arch(wasm32)
        public func render() -> JSValue {
            let document = JSObject.global.document
            let element = document.createElement("div")
            element.append(body.render())
            return element
        }
    #else
        public func render() -> String {
            "<div>\(body.render())</div>"
        }
    #endif
}
