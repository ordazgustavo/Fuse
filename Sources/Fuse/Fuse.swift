#if arch(wasm32)
import JavaScriptKit
#endif

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

    // var body: some Node {
    //    for item in data {
    //        content(item)
    //    }
    // }

    public func render(_ ctx: ServerHydrationContext) {
        for item in data {
            content(item).render(ctx)
        }
    }

    #if arch(wasm32)
    public func render(_ ctx: RenderContext) -> JSValue {
        let fragment = ctx.document.createDocumentFragment()
        for item in data {
            let content = content(item).render(ctx)
            fragment.append(content)
        }
        return fragment
    }

    public func hydrate(_ ctx: ClientHydrationContext) {
        for item in data {
            content(item).hydrate(ctx)
        }
    }
    #endif
}

public struct Fragment<C1: Node, C2: Node>: Node {
    let first: C1
    let second: C2

    public func render(_ ctx: ServerHydrationContext) {
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

    public func hydrate(_ ctx: ClientHydrationContext) {
        first.hydrate(ctx)
        second.hydrate(ctx)
    }
    #endif
}

extension String: Node {
    public func render(_ ctx: ServerHydrationContext) {
        ctx.buffer.append(contentsOf: self)
    }

    #if arch(wasm32)
    public func render(_: RenderContext) -> JSValue {
        jsValue
    }

    public func hydrate(_: ClientHydrationContext) {
        // Do nothing
    }
    #endif
}
