import Vapor
import JWT

struct AdminAuthenticator: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        guard let user = request.auth.get(UserPayload.self) else {
            return .init(status: .unauthorized)
        }

        // check if user is admin
//        guard user.role === "admin" else {
//            return .init(status: .forbidden)
//        }

        return .init(status: .ok)
    }
}
