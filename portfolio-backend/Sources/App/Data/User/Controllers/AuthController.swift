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
        let user = try await repository.verify(userRequest)
        let token = try UserJWT.generateToken(for: user, req: req)
        return .init(jwt: token)
    }

    @Sendable
    func register(req: Request) async throws -> HTTPStatus {
        var userInput = try req.content.decode(UserInput.self)
        if let imageFile = userInput.image {
            let imageURL = try await ImageUseCase().upload(imageFile, on: req)
            userInput.imagePath = imageURL
        }
        try await repository.create(userInput)
        return .created
    }
}
