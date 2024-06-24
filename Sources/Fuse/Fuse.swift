#if arch(wasm32)
import JavaScriptKit
#endif

public protocol Node {
    func render(_ ctx: HydrationContext)
    #if arch(wasm32)
    func render(_ ctx: RenderContext) -> JSValue
    func hydrate(_ ctx: HydrationContext)
    #endif
}

public extension Node {
    func div() -> Element<Tag.div> {
        Element(tag: "div")
    }

    func div(@ComponentBuilder content: () -> some Node) -> Element<Tag.div> {
        Element(tag: "div", child: content())
    }
}

public struct Fragment<C1: Node, C2: Node>: Node {
    let first: C1
    let second: C2

    public func render(_ ctx: HydrationContext) {
        first.render(ctx)
        second.render(ctx)
    }

    #if arch(wasm32)
    public func render(_ ctx: RenderContext) -> JSValue {
        let fragment = ctx.document.createDocumentFragment()
        fragment.append(first.render(ctx))
        fragment.append(second.render(ctx))
        return fragment
    }

    public func hydrate(_ ctx: HydrationContext) {
        first.hydrate(ctx)
        second.hydrate(ctx)
    }
    #endif
}

public enum Tag {
    public enum div {}
}

public struct Element<T>: Node {
    let tag: String
    let attr: [String: String]
    let child: Node?

    init(tag: String, attr: [String: String] = [:], child: Node? = nil) {
        self.tag = tag
        self.attr = attr
        self.child = child
    }

    public func render(_ ctx: HydrationContext) {
        let attr = renderAttr()
        let idx = ctx.index
        ctx.index += 1
        ctx.buffer.append(contentsOf: "<\(tag) data-hk=\"\(idx)\" \(attr)")
        if let child {
            ctx.buffer.append(">")
            child.render(ctx)
            ctx.buffer.append(contentsOf: "</\(tag)>")
        } else {
            ctx.buffer.append(contentsOf: "/>")
        }
    }

    #if arch(wasm32)
    public func render(_ ctx: RenderContext) -> JSValue {
        let element = ctx.document.createElement(tag)
        for (key, value) in attr {
            element.setAttribute(key, value)
        }
        if let child {
            let children = child.render(ctx)
            element.append(children)
        }
        return element
    }

    public func hydrate(_ ctx: HydrationContext) {
        print("Hydrating \(tag) with data-hk=\(ctx.index)")
        let ssrElement = ctx.document.querySelector("[data-hk=\"\(ctx.index)\"]")
        guard ssrElement != .undefined else { fatalError("Could not find data-hk=\(ctx.index)") }
        print("Hydrated \(tag) with data-hk=\(ctx.index)")
        ctx.index += 1
        child?.hydrate(ctx)
    }
    #endif

    func renderAttr() -> String {
        attr.reduce(into: "", attrParser)
    }

    func attrParser(_ acc: inout String, _ item: (key: String, value: String)) {
        acc.append(" \(item.key)=\"\(item.value)\"")
    }
}

extension Element where T == Tag.div {
    func id(_ value: String) -> Self {
        var attr = attr
        attr["id"] = value
        return .init(tag: tag, attr: attr, child: child)
    }
}

extension String: Node {
    public func render(_ ctx: HydrationContext) {
        ctx.buffer.append(contentsOf: self)
    }

    #if arch(wasm32)
    public func render(_: RenderContext) -> JSValue {
        jsValue
    }

    public func hydrate(_: HydrationContext) {
        // Do nothing
    }
    #endif
}

public protocol Component: Node {
    associatedtype Body: Node
    var body: Body { get }
}

public extension Component {
    func render(_ ctx: HydrationContext) {
        body.render(ctx)
    }

    #if arch(wasm32)
    func render(_ ctx: RenderContext) -> JSValue {
        body.render(ctx)
    }

    func hydrate(_ ctx: HydrationContext) {
        body.hydrate(ctx)
    }
    #endif
}

@resultBuilder
public struct ComponentBuilder {
    public static func buildBlock<C: Node>(_ component: C) -> C {
        component
    }

    public static func buildPartialBlock<C: Node>(first: C) -> C {
        first
    }

    public static func buildPartialBlock<C1: Node, C2: Node>(
        accumulated: C1, next: C2
    ) -> Fragment<C1, C2> {
        Fragment(first: accumulated, second: next)
    }
}
