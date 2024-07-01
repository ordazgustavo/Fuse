public final class ServerHydrationContext {
    var index = 0
    var buffer = ""
}

public func renderToString(component cmp: some Node) -> String {
    let ctx = ServerHydrationContext()
    cmp.render(ctx)
    return ctx.buffer
}
