import Fuse
import Hummingbird

struct HTML<C: Component>: ResponseGenerator {
    let cmp: C

    public func response(from _: Request, context: some RequestContext) throws -> Response {
        let template = renderToString(component: cmp)
        let buffer = context.allocator.buffer(string: template)
        return .init(
            status: .ok,
            headers: [.contentType: "text/html"],
            body: .init(byteBuffer: buffer)
        )
    }
}
