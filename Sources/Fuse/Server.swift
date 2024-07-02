public func renderToString(component cmp: some Node) -> String {
    let ctx = HydrationContext()
    cmp.render(ctx)
    return ctx.buffer
}
