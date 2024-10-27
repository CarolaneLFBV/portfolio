import Fluent
import JWTKit
import Vapor

struct AuthController: RouteCollection {
    let repository: AuthRepository

    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post("login", use: self.login)
        auth.post("register", use: self.register)
    }
}

extension AuthController {
    @Sendable
    func login(req: Request) async throws -> TokenDTO {
        let userRequest = try req.content.decode(User.LoginCredentials.self)

        guard let user = try await repository.findUserByEmail(userRequest.email) else {
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
    func register(req: Request) async throws -> UserDTO {
        let userRequest = try req.content.decode(UserDTO.self)

        guard let password = userRequest.password, !password.isEmpty else {
            throw Failed.invalidData
        }
        let passwordHash = try Bcrypt.hash(password)

        guard try await repository.findUserByEmail(userRequest.email) == nil else {
               throw Abort(.conflict, reason: "Email already exists")
        }

        let user = User(
            imageURL: userRequest.imageURL ?? "",
            fullName: userRequest.fullName,
            bio: userRequest.bio ?? "",
            role: userRequest.role,
            email: userRequest.email,
            password: passwordHash,
            introduction: userRequest.introduction ?? "",
            interests: userRequest.interests ?? []
        )

        try await repository.saveUser(user)
        return user.toDTO()
    }
}
