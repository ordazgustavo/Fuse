import Fuse

struct Title: Component {
    var body: some Node {
        div {
            "Hello"
        }
    }
}

public struct App: Component {
    public var body: some Node {
        div {
            Title()
            div {
                "World"
            }
        }
    }

    public init() {}
}
