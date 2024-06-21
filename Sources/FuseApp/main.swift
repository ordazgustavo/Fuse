import Fuse

@main
struct App {
    static func main() {
        let app = div {
            text("Hello")
            text(",")
            text(" world!")
        }
        launch(app: app)
    }
}
