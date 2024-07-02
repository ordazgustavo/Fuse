import JavaScriptKit

public protocol Node {
    func render(_ ctx: HydrationContext)
    func render(_ ctx: RenderContext) -> JSValue
    func hydrate(_ ctx: HydrationContext)
}

// MARK: - a

public extension Node {
    func a() -> Element<Tag.a> {
        Element(tag: "a")
    }

    func a(href: String, @ComponentBuilder content: () -> some Node) -> Element<Tag.a> {
        Element(tag: "a", attr: ["href": href], child: content())
    }
}

// MARK: - abbr

public extension Node {
    func abbr() -> Element<Tag.abbr> {
        Element(tag: "abbr")
    }

    func abbr(_ text: String) -> Element<Tag.abbr> {
        Element(tag: "abbr", child: text)
    }

    func abbr(title: String, @ComponentBuilder content: () -> some Node) -> Element<Tag.abbr> {
        Element(tag: "abbr", attr: ["title": title], child: content())
    }
}

// MARL: - address

public extension Node {
    func address() -> Element<Tag.address> {
        Element(tag: "address")
    }

    func address(@ComponentBuilder content: () -> some Node) -> Element<Tag.address> {
        Element(tag: "address", child: content())
    }
}

// MARK: - body

public extension Node {
    func body(@ComponentBuilder content: () -> some Node) -> Element<Tag.body> {
        Element(tag: "body", child: content())
    }
}

// MARK: - button

public extension Node {
    func button(
        type: Element<Tag.button>.ButtonType,
        @ComponentBuilder content: () -> some Node
    ) -> Element<Tag.button> {
        Element(tag: "button", attr: ["type": type.rawValue], child: content())
    }

    func button(@ComponentBuilder content: () -> some Node) -> Element<Tag.button> {
        Element(tag: "button", child: content())
    }
}

// MARK: - div

public extension Node {
    func div() -> Element<Tag.div> {
        Element(tag: "div")
    }

    func div(@ComponentBuilder content: () -> some Node) -> Element<Tag.div> {
        Element(tag: "div", child: content())
    }
}

// MARK: - form

public extension Node {
    func form(@ComponentBuilder content: () -> some Node) -> Element<Tag.form> {
        Element(tag: "form", child: content())
    }

    func form(method: String, @ComponentBuilder content: () -> some Node) -> Element<Tag.form> {
        Element(tag: "form", attr: ["method": method], child: content())
    }
}

// MARK: - h

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

// MARK: - head

public extension Node {
    func head(@ComponentBuilder content: () -> some Node) -> Element<Tag.head> {
        Element(tag: "head", child: content())
    }
}

// MARK: - html

public extension Node {
    func html(@ComponentBuilder content: () -> some Node) -> Element<Tag.html> {
        Element(tag: "html", child: content())
    }

    func html(lang: String, @ComponentBuilder content: () -> some Node) -> Element<Tag.html> {
        Element(tag: "html", attr: ["lang": lang], child: content())
    }
}

// MARK: - input

public extension Node {
    func input(type: String) -> Element<Tag.input> {
        Element(tag: "input", attr: ["type": type])
    }

    // func input(type: String) -> Element<Tag.input> {
    //    Element(tag: "input", attr: ["type": type])
    // }

    func input(type: String, value: Binding<String>) -> Element<Tag.input> {
        Element(
            tag: "input",
            attr: ["type": type, "value": value.wrappedValue],
            events: ["input": { value.wrappedValue = $0.target.value.string ?? "" }]
        )
    }
}

// MARK: - link

public extension Node {
    func link(rel: String, href: String, type: String? = .none) -> Element<Tag.link> {
        let attr: [String: String] = type.map { ["rel": rel, "href": href, "type": $0] } ?? ["rel": rel, "href": href]
        return Element(tag: "link", attr: attr)
    }
}

// MARK: - main

public extension Node {
    func main(@ComponentBuilder content: () -> some Node) -> Element<Tag.main> {
        Element(tag: "main", child: content())
    }
}

// MARK: - meta

public extension Node {
    func meta(charset: String) -> Element<Tag.meta> {
        Element(tag: "meta", attr: ["charset": charset])
    }

    func meta(name: String, content: String) -> Element<Tag.meta> {
        Element(tag: "meta", attr: ["name": name, "content": content])
    }

    func meta(httpEquiv: String, content: String) -> Element<Tag.meta> {
        Element(tag: "meta", attr: ["http-equiv": httpEquiv, "content": content])
    }
}

// MARK: - p

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

// MARK: - script

public extension Node {
    func script(type: String? = .none, src: String) -> Element<Tag.script> {
        let attr: [String: String] = type.map { ["type": $0, "src": src] } ?? ["src": src]
        return Element(tag: "script", attr: attr, isVoid: false)
    }

    func script(@ComponentBuilder content: () -> some Node) -> Element<Tag.script> {
        Element(tag: "script", child: content())
    }
}

// MARK: - span

public extension Node {
    func span() -> Element<Tag.span> {
        Element(tag: "span")
    }

    func span(_ text: String) -> Element<Tag.span> {
        Element(tag: "span", child: text)
    }

    func span(@ComponentBuilder content: () -> some Node) -> Element<Tag.span> {
        Element(tag: "span", child: content())
    }
}

// MARK: - title

public extension Node {
    func title(_ text: String) -> Element<Tag.title> {
        Element(tag: "title", child: text)
    }
}

// MARK: - table

public extension Node {
    func table(@ComponentBuilder content: () -> some Node) -> Element<Tag.table> {
        Element(tag: "table", child: content())
    }
}

// MARK: - tbody

public extension Node {
    func tbody(@ComponentBuilder content: () -> some Node) -> Element<Tag.tbody> {
        Element(tag: "tbody", child: content())
    }
}

// MARK: - td

public extension Node {
    func td() -> Element<Tag.td> {
        Element(tag: "td")
    }

    func td(@ComponentBuilder content: () -> some Node) -> Element<Tag.td> {
        Element(tag: "td", child: content())
    }
}

// MARK: - tr

public extension Node {
    func tr(@ComponentBuilder content: () -> some Node) -> Element<Tag.tr> {
        Element(tag: "tr", child: content())
    }
}
