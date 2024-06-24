#if arch(wasm32)
import JavaScriptKit
#endif

public final class HydrationContext {
    #if arch(wasm32)
    var document = JSObject.global.document
    #endif
    var index = 0
    var buffer = ""
}

public func renderToString(component cmp: some Node) -> String {
    let ctx = HydrationContext()
    cmp.render(ctx)
    return ctx.buffer
}
