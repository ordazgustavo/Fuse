import JavaScriptKit

class Ref<T> {
    var current: T
    init(_ value: T) {
        current = value
    }
}

@propertyWrapper
public struct Signal<T> {
    private var value: Ref<T>
    private var subscriptions: Ref<[(T) -> Void]> = Ref([])

    public var wrappedValue: T {
        get { value.current }
        nonmutating set {
            value.current = newValue
            subscriptions.current.forEach { $0(newValue) }
        }
    }

    public init(wrappedValue: T) {
        value = .init(wrappedValue)
    }

    public var projectedValue: Binding<T> {
        Binding(
            get: { value.current },
            set: { newValue in
                value.current = newValue
                subscriptions.current.forEach { $0(newValue) }
            }
        )
    }

    public func observe(_ observer: @escaping (T) -> Void) {
        subscriptions.current.append(observer)
    }
}

extension Signal: Node {
    public func render(_: HydrationContext) {
        // ctx.document.createTextNode("\(wrappedValue)")
    }

    public func render(_ ctx: RenderContext) -> JSValue {
        var node = ctx.document.createTextNode("\(wrappedValue)")
        observe { value in
            node.textContent = .string("\(value)")
        }
        return node
    }

    public func hydrate(_: HydrationContext) {
        // ctx.document.createTextNode("\(wrappedValue)")
    }
}

@propertyWrapper
public struct Binding<T> {
    private var get: () -> T
    private var set: (T) -> Void

    public var wrappedValue: T {
        get { get() }
        nonmutating set { set(newValue) }
    }

    init(get: @escaping () -> T, set: @escaping (T) -> Void) {
        self.get = get
        self.set = set
    }
}
