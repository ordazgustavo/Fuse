import App
import Hummingbird

public protocol ServerArguments {
    var hostname: String { get }
    var port: Int { get }
}

func buildApplication(_ arguments: some ServerArguments) async throws -> some ApplicationProtocol {
    let router = Router()

    router.middlewares.add(FileMiddleware("Bundle", searchForIndexHtml: false))

    router.get("/health") { _, _ in
        HTTPResponse.Status.ok
    }

    router.get("/") { _, _ -> HTML in
        HTML(html: App())
    }

    // create application using router
    let app = Application(
        router: router,
        configuration: .init(address: .hostname(arguments.hostname, port: arguments.port))
    )

    return app
}
