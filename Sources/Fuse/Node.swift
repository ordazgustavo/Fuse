#if arch(wasm32)
import JavaScriptKit
#endif

public protocol Node {
    func render(_ ctx: HydrationContext)
    #if arch(wasm32)
    func render(_ ctx: RenderContext) -> JSValue
    func hydrate(_ ctx: HydrationContext)
    #endif
}

public extension Node {
    func div() -> Element<Tag.div> {
        Element(tag: "div")
    }

    func div(@ComponentBuilder content: () -> some Node) -> Element<Tag.div> {
        Element(tag: "div", child: content())
    }
}

public extension Node {
    func h1() -> Element<Tag.h> {
        Element(tag: "h1")
    }

    func h1(_ text: String) -> Element<Tag.h> {
        Element(tag: "h1", child: text)
    }

    func h1(@ComponentBuilder content: () -> some Node) -> Element<Tag.h> {
        Element(tag: "h1", child: content())
    }
}

public extension Node {
    func p() -> Element<Tag.p> {
        Element(tag: "p")
    }

    func p(_ text: String) -> Element<Tag.p> {
        Element(tag: "p", child: text)
    }

    func p(@ComponentBuilder content: () -> some Node) -> Element<Tag.p> {
        Element(tag: "p", child: content())
    }
}
