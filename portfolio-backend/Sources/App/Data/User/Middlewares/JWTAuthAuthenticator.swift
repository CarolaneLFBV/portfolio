import Vapor
import JWT

struct JWTAuthAuthenticator: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {

        guard let token = request.headers.bearerAuthorization?.token else {
            throw Failed.invalidData
        }

        let secretKey = Environment.get("JWT_SECRET")!
        let signer = JWTSigner.hs256(key: secretKey)
        let payload = try signer.verify(token, as: UserJWT.self)

        guard let userJWT = try await User.find(UUID(payload.subject.value), on: request.db) else {
            throw Failed.idNotFound
        }

        let user = User(
            id: userJWT.id,
            firstName: userJWT.firstName ?? "",
            lastName: userJWT.lastName ?? "",
            email: userJWT.email,
            password: userJWT.password,
            role: userJWT.role
        )
        request.auth.login(user)

        return try await next.respond(to: request)
    }
}
