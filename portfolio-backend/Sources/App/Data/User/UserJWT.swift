import Vapor
import JWT

struct UserJWT: JWTPayload {
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case role
    }

    enum TokenExpiration: TimeInterval {
        case oneHour = 3600
        case oneDay = 86400
        case oneWeek = 604800
    }

    var subject: SubjectClaim
    var expiration: ExpirationClaim
    var role: UserRole

    func verify(using signer: JWTKit.JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}

extension UserJWT {
    static func generateToken(for user: User.Entity, req: Request) throws -> String {

        let userJWT = UserJWT(
            subject: .init(value: user.id!.uuidString),
            expiration: .init(value: Date().addingTimeInterval(TokenExpiration.oneHour.rawValue)),
            role: user.role
        )

        let jwt = try req.application.jwt.signers.sign(userJWT)
        return jwt
    }
}
