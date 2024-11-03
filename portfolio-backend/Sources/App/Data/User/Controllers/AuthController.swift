import Fluent
import JWTKit
import Vapor

extension User.Controllers {
    struct AuthConfig: RouteCollection {
        typealias UserOutput = User.Dto.Output
        typealias UserInput = User.Dto.Input
        let repository: User.Repositories.AuthRepository

        func boot(routes: RoutesBuilder) throws {
            let auth = routes.grouped("auth")
            auth.post("login", use: self.login)
            auth.post("register", use: self.register)
        }
    }
}

extension User.Controllers.AuthConfig {
    @Sendable
    func login(req: Request) async throws -> TokenDTO {
        let userRequest = try req.content.decode(User.Entity.LoginCredentials.self)

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
    func register(req: Request) async throws -> UserOutput {
        let userInput = try req.content.decode(UserInput.self)

        guard let password = userInput.password, !password.isEmpty else {
            throw Failed.invalidData
        }
        let passwordHash = try Bcrypt.hash(password)

        guard try await repository.findUserByEmail(userInput.email) == nil else {
            throw Abort(.conflict, reason: "Email already exists")
        }

        let user = userInput.toModel()

        if let imageFile = userInput.image {
            let imageURL = try await ImageUseCase().upload(imageFile, on: req)
            user.imageURL = imageURL
        }

        user.password = passwordHash

        try await repository.saveUser(user)
        return UserOutput(from: user)
    }
}
