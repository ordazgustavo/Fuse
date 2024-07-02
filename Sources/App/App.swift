import Fuse

struct MyBytton: Component {
    @Binding var count: Int

    var body: some Node {
        div {
            button { "+" }
                .on(.click) { _ in
                    count += 1
                }
            button { "-" }
                .on(.click) { _ in
                    count -= 1
                }
        }
    }
}

public struct App: Component {
    @Signal private var count = 0
    @Signal private var name = "Gustavo"
    @Signal private var surename = ""

    public var body: some Node {
        div {
            "The count is: "
            _count
            MyBytton(count: $count)

            div {
                "The name is: "
                _name
            }
            input(type: "text", value: $name)

            div {
                "The surename is: "
                _surename
            }
            input(type: "text")
                .on(.input) { event in
                    surename = event.target.value.string ?? ""
                }
        }
    }

    public init() {
        _count.observe { count in
            print("Count is \(count)")
        }
        _name.observe { name in
            print("Name is \(name)")
        }
    }
}
