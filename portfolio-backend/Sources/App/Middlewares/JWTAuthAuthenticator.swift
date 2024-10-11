import Vapor
import JWT

struct JWTAuthAuthenticator: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {

        // Extract token from headers
        guard let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "Token missing from headers")
        }

        // Validate token from secretKey
        let secretKey = Environment.get("JWT_SECRET")!
        let signer = JWTSigner.hs256(key: secretKey)
        let payload = try signer.verify(token, as: UserJWT.self)

        // Retrieve user from JWT (sub field)
        guard let userJWT = try await User.find(UUID(payload.subject.value), on: request.db) else {
            throw Abort(.notFound, reason: "User not found")
        }

        // Authenticate user in request
        let user = User(
            id: userJWT.id,
            firstName: userJWT.firstName ?? "",
            lastName: userJWT.lastName ?? "",
            email: userJWT.email,
            password: userJWT.password,
            role: userJWT.role
        )
        request.auth.login(user)

        // Continue request treatment
        return try await next.respond(to: request)
    }
}
