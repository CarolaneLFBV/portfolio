import Fluent
import JWTKit
import Vapor

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post("login", use: login)
        auth.post("register", use: register)
    }
}

extension AuthController {
    @Sendable
    func login(req: Request) async throws -> TokenDTO {
        let userRequest = try req.content.decode(User.LoginCredentials.self)

        // Verify mail
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == userRequest.email)
            .first() else {
            throw Abort(.notFound, reason: "User not found")
        }

        // Verify password
        let isValidPassword = try Bcrypt.verify(userRequest.password, created: user.password)
        guard isValidPassword else {
            throw Abort(.unauthorized, reason: "Invalid password")
        }

        let token = try UserJWT.generateToken(for: user, req: req)
        return .init(jwt: token)
    }

    @Sendable
    func register(req: Request) async throws -> TokenDTO {
        let userRequest = try req.content.decode(UserDTO.self)
        let passwordHash = try Bcrypt.hash(userRequest.password ?? "defaultPassword")

        // Check email
        guard try await User.query(on: req.db)
            .filter(\.$email == userRequest.email)
            .first() == nil else {
                throw Abort(.conflict, reason: "Email already exists")
            }

        // Create user
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
