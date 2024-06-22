import Fuse
import Hummingbird

struct HTML<C: Component>: ResponseGenerator {
    let html: C

    public func response(from _: Request, context: some RequestContext) throws -> Response {
        let template = """
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <script type="module" src="d8a521ccff723a59.js"></script>
          </head>
          <body>
          \(html.render())
          </body>
        </html>
        """
        let buffer = context.allocator.buffer(string: template)
        return .init(
            status: .ok,
            headers: [.contentType: "text/html"],
            body: .init(byteBuffer: buffer)
        )
    }
}
