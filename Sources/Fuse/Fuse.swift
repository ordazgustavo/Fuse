#if arch(wasm32)
import JavaScriptKit
#endif

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
