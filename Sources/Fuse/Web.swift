#if arch(wasm32)
public func render(component cmp: some Component) {
    let ctx = RenderContext()
    let element = cmp.render(ctx)
    ctx.document.body.append(element)
}

public func hydrate(component cmp: some Component) {
    let ctx = HydrationContext()
    cmp.hydrate(ctx)
}
#endif
