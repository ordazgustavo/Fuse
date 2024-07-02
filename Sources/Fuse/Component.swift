import JavaScriptKit

public protocol Component: Node {
    associatedtype Body: Node
    var body: Body { get }
}

public extension Component {
    func render(_ ctx: HydrationContext) {
        ctx.hydrate = true
        body.render(ctx)
    }

    func render(_ ctx: RenderContext) -> JSValue {
        body.render(ctx)
    }

    func hydrate(_ ctx: HydrationContext) {
        print("hydrating \(Self.self)")
        ctx.hydrate = true
        body.hydrate(ctx)
    }
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
