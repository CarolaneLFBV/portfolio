import Vapor
import JWT

struct RoleMiddleware: AsyncMiddleware {
    let requiredRole: User.Role

    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        let user = try request.auth.require(User.self)

        guard user.role == requiredRole else {
            throw Failed.accessDenied
        }

        return try await next.respond(to: request)
    }
}
