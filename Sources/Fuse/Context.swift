import JavaScriptKit

public final class HydrationContext {
    var document = JSObject.global.document
    var index = 0
    var buffer = ""
    var hydrate = false

    func getID() -> String {
        defer {
            index += 1
            hydrate = false
        }
        return "\(index)"
    }
}
