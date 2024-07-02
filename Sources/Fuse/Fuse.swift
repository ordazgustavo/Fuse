import JavaScriptKit

public struct ForEach<Data, Content: Node>: Node where Data: RandomAccessCollection {
    let data: Data
    // let id: KeyPath<Data.Element, ID>
    @ComponentBuilder let content: (Data.Element) -> Content

    public init(
        _ data: Data,
        // id: KeyPath<Data.Element, ID>,
        @ComponentBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        // self.id = id
        self.content = content
    }

    public func render(_ ctx: HydrationContext) {
        for item in data {
            content(item).render(ctx)
        }
    }

    public func render(_ ctx: RenderContext) -> JSValue {
        let fragment = ctx.document.createDocumentFragment()
        for item in data {
            let content = content(item).render(ctx)
            _ = fragment.append(content)
        }
        return fragment
    }

    public func hydrate(_ ctx: HydrationContext) {
        for item in data {
            content(item).hydrate(ctx)
        }
    }
}

public struct Fragment<C1: Node, C2: Node>: Node {
    let first: C1
    let second: C2

    public func render(_ ctx: HydrationContext) {
        first.render(ctx)
        second.render(ctx)
    }

    public func render(_ ctx: RenderContext) -> JSValue {
        let fragment = ctx.document.createDocumentFragment()
        _ = fragment.append(first.render(ctx))
        _ = fragment.append(second.render(ctx))
        return fragment
    }

    public func hydrate(_ ctx: HydrationContext) {
        first.hydrate(ctx)
        second.hydrate(ctx)
    }
}

extension String: Node {
    public func render(_ ctx: HydrationContext) {
        ctx.buffer.append(contentsOf: self)
    }

    public func render(_: RenderContext) -> JSValue {
        jsValue
    }

    public func hydrate(_: HydrationContext) {
        // Do nothing
    }
}
