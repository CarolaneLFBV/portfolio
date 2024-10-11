import Vapor
import JWT

struct UserJWT: JWTPayload {
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case role
    }

    var subject: SubjectClaim
    var expiration: ExpirationClaim
    var role: User.Role

    // Mandatory to validate JWT token
    func verify(using signer: JWTKit.JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}

extension UserJWT {
    // Route to generate a JWT after the user's login
    static func generateToken(for user: User, req: Request) throws -> String {

        // Payload JWT
        let userJWT = UserJWT(
            subject: .init(value: user.id!.uuidString),
            expiration: .init(value: Date().addingTimeInterval(3600)),
            role: user.role
        )

        let secretKey = Environment.get("JWT_SECRET")!

        // Generate & Sign JWT
        let jwt = try req.application.jwt.signers.sign(userJWT)
        return jwt
    }
}
