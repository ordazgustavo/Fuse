import Benchmark
import Fuse
import Foundation

let adjectives = ["pretty", "large", "big", "small", "tall", "short", "long", "handsome", "plain", "quaint", "clean", "elegant", "easy", "angry", "crazy", "helpful", "mushy", "odd", "unsightly", "adorable", "important", "inexpensive", "cheap", "expensive", "fancy"];

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

struct App: Component {
    let rows: Int

    var data: [RowData] {
        buildData(rows)
    }

    var body: some Node {
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
}

let benchmarks = {
    Benchmark.defaultConfiguration = .init(
        metrics: [
            // .cpuTotal,
            .throughput,
            // .mallocCountTotal,
            // .all
        ],
        warmupIterations: 10
    )

    Benchmark("Render to string 10 rows") { _ in
        blackHole(renderToString(component: App(rows: 10)))
    }

    Benchmark("Render to string 100 rows") { _ in
        blackHole(renderToString(component: App(rows: 100)))
    }

    Benchmark("Render to string 1000 rows") { _ in
        blackHole(renderToString(component: App(rows: 1000)))
    }
}
