import App
import Fuse

@main
public struct Client {
    public static func main() {
        render(component: App())
        // hydrate(component: Document(src: "/index.js"))
    }
}
