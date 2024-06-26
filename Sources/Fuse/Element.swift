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
        let idx = ctx.index

        ctx.buffer.append("<\(tag) data-hk=\"\(idx)\"")

        for (key, value) in attr {
            ctx.buffer.append(" \(key)=\"\(value)\"")
        }

        if let child {
            ctx.buffer.append(">")
            ctx.index += 1
            child.render(ctx)
            ctx.buffer.append("</\(tag)>")
        } else {
            ctx.buffer.append("/>")
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
        let selector = "data-hk=\"\(ctx.index)\""

        print("Hydrating \(tag) with \(selector)")

        let ssrElement = ctx.document.querySelector("[\(selector)]")
        guard ssrElement != .undefined else { fatalError("Could not find \(selector)") }

        print("Hydrated \(tag) with \(selector)")

        ctx.index += 1
        child?.hydrate(ctx)
    }
    #endif
}

extension Element where T == Tag.div {
    func id(_ value: String) -> Self {
        var attr = attr
        attr["id"] = value
        return .init(tag: tag, attr: attr, child: child)
    }
}
