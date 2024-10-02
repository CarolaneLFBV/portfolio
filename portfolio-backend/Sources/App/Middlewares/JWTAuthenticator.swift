import Vapor
import JWT

struct JWTAuthenticator: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        do {
            let payload = try request.jwt.verify(as: UserPayload.self)
            guard let user = try await User.find(UUID(payload.subject.value), on: request.db) else {
                return .init(status: .unauthorized)
            }
            request.auth.login(user)
            return try await next.respond(to: request)
        } catch {
            return .init(status: .unauthorized)
        }
    }
}
