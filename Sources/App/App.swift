import Foundation
import Fuse

let adjectives = [
    "pretty",
    "large",
    "big",
    "small",
    "tall",
    "short",
    "long",
    "handsome",
    "plain",
    "quaint",
    "clean",
    "elegant",
    "easy",
    "angry",
    "crazy",
    "helpful",
    "mushy",
    "odd",
    "unsightly",
    "adorable",
    "important",
    "inexpensive",
    "cheap",
    "expensive",
    "fancy",
]

struct RowData: Identifiable {
    let id = UUID()
    let label: String
}

func buildData(_ count: Int) -> [RowData] {
    var data = [RowData]()
    for _ in 0 ..< count {
        data.append(.init(label: adjectives.randomElement()!))
    }
    return data
}

public struct App: Component {
    let rows: Int

    var data: [RowData] {
        buildData(rows)
    }

    public var body: some Node {
        table {
            tbody {
                ForEach(data) { row in
                    tr {
                        td { "\(row.id)" }
                        td { row.label }
                    }
                }
            }
        }
    }

    public init(rows: Int = 1000) {
        self.rows = rows
    }
}
