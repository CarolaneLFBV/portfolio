import Vapor
import JWT

extension User.Middlewares {
    struct JWTAuthAuthenticator: AsyncMiddleware {
        func respond(
            to request: Vapor.Request,
            chainingTo next: any Vapor.AsyncResponder
        ) async throws -> Vapor.Response {
            guard let token = request.headers.bearerAuthorization?.token else {
                throw Failed.invalidData
            }

            let secretKey = Environment.get("JWT_SECRET")!
            let signer = JWTSigner.hs256(key: secretKey)
            let payload = try signer.verify(token, as: UserJWT.self)

            guard let userJWT = try await User.Entity.find(UUID(payload.subject.value), on: request.db) else {
                throw Failed.idNotFound
            }

            let user = User.Entity(
                id: userJWT.id,
                imageURL: userJWT.imageURL ?? "",
                fullName: userJWT.fullName,
                bio: userJWT.bio,
                role: userJWT.role,
                email: userJWT.email,
                password: userJWT.password,
                introduction: userJWT.introduction,
                interests: userJWT.interests
            )
            request.auth.login(user)

            return try await next.respond(to: request)
        }
    }
}
