import Foundation
import Fuse
import Hummingbird

struct HTML<C: Component>: ResponseGenerator {
    let cmp: C

    public func response(from _: Request, context: some RequestContext) throws -> Response {
        let filePath = "public/index.html"
        let fileURL = URL(fileURLWithPath: filePath)
        let fileData = try Data(contentsOf: fileURL)
        var template = String(decoding: fileData, as: UTF8.self)
        if let range = template.range(of: "<body>") {
            let sub = template[range]
            template.insert(contentsOf: cmp.render(), at: sub.endIndex)
        }
        let buffer = context.allocator.buffer(string: template)
        return .init(
            status: .ok,
            headers: [.contentType: "text/html"],
            body: .init(byteBuffer: buffer)
        )
    }
}
