import Fuse

struct Title: Component {
    var body: some Node {
        div {
            h1("Hello, World!")
        }
    }
}

public struct App: Component {
    public var body: some Node {
        div {
            Title()
            div {
                p("Page description")
                "Just a text"
            }
        }
    }

    public init() {}
}
