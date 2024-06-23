#if arch(wasm32)
import JavaScriptKit
#endif

#if arch(wasm32)
public final class RenderContext {
    let document = JSObject.global.document
}
#endif

public final class HydrationContext {
    var index = 0
    #if arch(wasm32)
    let document = JSObject.global.document
    #endif
}

@resultBuilder
public struct ComponentBuilder {
    public static func buildBlock<C: Component>(_ component: C) -> C {
        component
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
    func render(_ ctx: RenderContext) -> JSValue
    func hydrate(_ ctx: HydrationContext) -> Void
    #else
    func render(_ ctx: HydrationContext) -> String
    #endif
}

public extension Component {
    #if arch(wasm32)
    func render(_ ctx: RenderContext) -> JSValue {
        body.render(ctx)
    }

    func hydrate(_ ctx: HydrationContext) {
        body.hydrate(ctx)
    }
    #else
    func render(_ ctx: HydrationContext) -> String {
        body.render(ctx)
    }
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
    #else
    public func render(_ ctx: HydrationContext) -> String {
        first.render(ctx) + second.render(ctx)
    }
    #endif
}

extension String: Component {
    public var body: some Component {
        self
    }

    #if arch(wasm32)
    public func render() -> JSValue {
        jsValue
    }

    public func hydrate(_: HydrationContext) {
        // Do nothing
    }
    #else
    public func render(_: HydrationContext) -> String {
        self
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
    public func render(_ ctx: RenderContext) -> JSValue {
        let element = ctx.document.createElement("div")
        element.append(body.render(ctx))
        return element
    }

    public func hydrate(_ ctx: HydrationContext) {
        let ssrElement = ctx.document.querySelector("[data-hk=\"\(ctx.index)\"]")
        print("Hydrating pre:", ssrElement)
        guard ssrElement != .undefined else { fatalError("could not find data-hk=\(ctx.index)") }
        print("Hydrating post:", ssrElement)
        ctx.index += 1
        body.hydrate(ctx)
    }
    #else
    public func render(_ ctx: HydrationContext) -> String {
        let a = "<div data-hk=\"\(ctx.index)\">"
        ctx.index += 1
        let b = body.render(ctx)
        let c = "</div>"
        return a + b + c
    }
    #endif
}
