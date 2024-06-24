#if arch(wasm32)
import JavaScriptKit

public class RenderContext {
    var document = JSObject.global.document
}

public func render(component cmp: some Node) {
    let ctx = RenderContext()
    let element = cmp.render(ctx)
    ctx.document.body.append(element)
}

public func hydrate(component cmp: some Node) {
    let ctx = HydrationContext()
    cmp.hydrate(ctx)
}
#endif
