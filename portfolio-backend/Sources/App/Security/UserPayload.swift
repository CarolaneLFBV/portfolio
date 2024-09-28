import Vapor
import JWT

struct UserPayload: JWTPayload, Authenticatable {
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case role
    }

    var subject: SubjectClaim
    var expiration: ExpirationClaim
    var role: Role

    func verify(using signer: JWTKit.JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}
