#if arch(wasm32)
import JavaScriptKit

public final class ClientHydrationContext {
    var document = JSObject.global.document
    var index = 0
    var buffer = ""
}

public class RenderContext {
    var document = JSObject.global.document
}

public func render(component cmp: some Node) {
    let ctx = RenderContext()
    let element = cmp.render(ctx)
    ctx.document.body.append(element)
}

public func hydrate(component cmp: some Node) {
    let ctx = ClientHydrationContext()
    cmp.hydrate(ctx)
}

extension StaticString: ConvertibleToJSValue {
    public var jsValue: JSValue {
        .string(withUTF8Buffer { String(decoding: $0, as: UTF8.self) })
    }
}
#endif
