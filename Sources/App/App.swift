import Fuse

struct Title: Component {
    var body: some Component {
        div {
            "Hello"
        }
    }
}

public struct App: Component {
    public var body: some Component {
        div {
            Title()
            div {
                "World"
            }
        }
    }

    public init() {}
}
