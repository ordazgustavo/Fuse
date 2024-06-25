#if arch(wasm32)
import JavaScriptKit
#endif

public enum Tag {
    public enum div {}
    public enum h {}
    public enum p {}
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
