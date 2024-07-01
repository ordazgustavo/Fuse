import Fuse

public struct Document: Component {
    public let src: String

    public var body: some Node {
        html(lang: "en") {
            head {
                meta(charset: "utf-8")
                meta(name: "viewport", content: "width=device-width, initial-scale=1")
                script(type: "module", src: src)
            }
            body {
                App()
            }
        }
    }

    public init(src: String) {
        self.src = src
    }
}
