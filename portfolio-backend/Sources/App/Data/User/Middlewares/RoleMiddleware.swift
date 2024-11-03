import Vapor
import JWT

extension User.Middlewares {
    struct RoleMiddleware: AsyncMiddleware {
        let requiredRole: UserRole

        func respond(
            to request: Vapor.Request,
            chainingTo next: any Vapor.AsyncResponder
        ) async throws -> Vapor.Response {
            let user = try request.auth.require(User.Entity.self)

            guard user.role == requiredRole else {
                throw Failed.accessDenied
            }

            return try await next.respond(to: request)
        }
    }
}
