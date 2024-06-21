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

public protocol Component {
    associatedtype Body: Component
    var body: Body { get }

    #if arch(wasm32)
        func render() -> JSValue
    #else
        func render() -> String
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

    public init(content: () -> C) {
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
