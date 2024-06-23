#if !arch(wasm32)
public func render(component cmp: some Component) -> String {
    let ctx = HydrationContext()
    return cmp.render(ctx)
}
#endif
