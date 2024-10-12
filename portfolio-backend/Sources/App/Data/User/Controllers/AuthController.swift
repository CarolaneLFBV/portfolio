import Fluent
import JWTKit
import Vapor

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post("login", use: self.login)
        
        let protected = auth.grouped([
            JWTAuthAuthenticator(),
            User.guardMiddleware(),
            RoleMiddleware(requiredRole: .admin)
        ])
        protected.post("register", use: self.register)
    }
}

extension AuthController {
    @Sendable
    func login(req: Request) async throws -> TokenDTO {
        let userRequest = try req.content.decode(User.LoginCredentials.self)

        guard let user = try await User.query(on: req.db)
            .filter(\.$email == userRequest.email)
            .first() else {
            throw Failed.idNotFound
        }

        let isValidPassword = try Bcrypt.verify(userRequest.password, created: user.password)
        guard isValidPassword else {
            throw Failed.invalidData
        }

        let token = try UserJWT.generateToken(for: user, req: req)
        return .init(jwt: token)
    }

    @Sendable
    func register(req: Request) async throws -> TokenDTO {
        let userRequest = try req.content.decode(UserDTO.self)

        guard let password = userRequest.password, !password.isEmpty else {
            throw Failed.invalidData
        }
        let passwordHash = try Bcrypt.hash(password)

        guard try await User.query(on: req.db)
            .filter(\.$email == userRequest.email)
            .first() == nil else {
                throw Abort(.conflict, reason: "Email already exists")
            }

        let user = User(
            firstName: userRequest.firstName ?? "",
            lastName: userRequest.lastName ?? "",
            email: userRequest.email,
            password: passwordHash,
            role: userRequest.role
        )

        try await user.save(on: req.db)

        let token = try UserJWT.generateToken(for: user, req: req)
        return .init(jwt: token)
    }
}
