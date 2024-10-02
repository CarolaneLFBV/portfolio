import Fluent
import JWTKit
import Vapor

struct AuthController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post("login", use: login)
        auth.post("register", use: register)
    }

    @Sendable
    func login(req: Request) async throws -> User.TokenResponse {
        let userRequest = try req.content.decode(User.LoginCredentials.self)

        // Check user by mail
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == userRequest.email)
            .first() else {
            throw Abort(.notFound, reason: "User not found")
        }

        // Check if password is valid
        let isValidPassword = try Bcrypt.verify(userRequest.password, created: user.password)
        guard isValidPassword else {
            throw Abort(.unauthorized, reason: "Invalid password")
        }

        // Generate JWT payload
        let payload = UserPayload(
            subject: .init(value: user.id!.uuidString),
            expiration: .init(value: Date().addingTimeInterval(3600)),
            role: user.role
        )

        // Sign JWT
        let token = try req.jwt.sign(payload)

        // Convert user to DTO for response data
        let userDTO = user.toDTO()
        let response = User.TokenResponse(user: userDTO, token: token)
        return response
    }

    @Sendable
    func register(req: Request) async throws -> User.TokenResponse {
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

        // Generate JWT
        let payload = UserPayload(
            subject: SubjectClaim(value: user.id!.uuidString),
            expiration: ExpirationClaim(value: Date().addingTimeInterval(3600)),
            role: user.role
        )

        let token = try req.jwt.sign(payload)
        let response = User.TokenResponse(user: user.toDTO(), token: token)

        // Return user and token
        return response
    }
}
