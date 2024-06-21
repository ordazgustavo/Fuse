import Fuse

@main
struct App {
    static func main() {
        let app = div {
            text("Hello, world!")
        }
        launch(app: app)
    }
}
