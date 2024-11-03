import Fluent
import Vapor

extension User.Controllers {
    struct Config: RouteCollection {
        typealias UserOutput = User.Dto.Output
        typealias UserInput = User.Dto.Input
        typealias UserRepository = User.Repositories.UserRepository

        private let repository: UserRepository

        init(repository: UserRepository) {
            self.repository = repository
        }

        func boot(routes: any RoutesBuilder) throws {
            let users = routes.grouped("users")
            users.get(use: self.index)
            users.get("current", use: self.getAuthenticatedUser)

            let protected = users.grouped([
                User.Middlewares.JWTAuthAuthenticator(),
                User.Middlewares.RoleMiddleware(requiredRole: .admin),
                User.Entity.guardMiddleware()
            ])
            let protectedElement = protected.grouped(":userId")
            protectedElement.get(use: self.getUser)
            protectedElement.patch(use: self.update)
            protectedElement.delete(use: self.delete)
        }
    }
}

extension User.Controllers.Config {
    @Sendable
    func index(req: Request) async throws -> [UserOutput] {
        let users = try await repository.findAll()
        return users.map { UserOutput(from: $0) }
    }

    @Sendable
    func getAuthenticatedUser(req: Request) async throws -> UserOutput {
        guard let user = req.auth.get(User.Entity.self) else {
            throw Failed.accessDenied
        }
        return UserOutput(from: user)
    }

    @Sendable
    func getUser(req: Request) async throws -> UserOutput {
        guard let user = try await User.Entity.find(req.parameters.get("userId"), on: req.db) else {
            throw Failed.idNotFound
        }

        return UserOutput(from: user)
    }

    @Sendable
    func update(req: Request) async throws -> UserOutput {
        guard let userId = req.parameters.get("userId", as: UUID.self),
              let user = try await repository.find(userId) else {
            throw Failed.idNotFound
        }

        let updatedUser = try req.content.decode(UserInput.self)
        user.fullName = updatedUser.fullName
        user.bio = updatedUser.bio
        user.role = updatedUser.role
        user.email = updatedUser.email
        user.introduction = updatedUser.introduction
        user.interests = updatedUser.interests

        if let image = updatedUser.image {
            let imageData = try await ImageUseCase().upload(image, on: req)
            user.imageURL = imageData
        }

        try await repository.saveUser(updatedUser, on: req)
        return UserOutput(from: user)
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let userId = req.parameters.get("userId", as: UUID.self),
              let user = try await repository.find(userId) else {
            throw Failed.idNotFound
        }
        try await repository.deleteUser(user)
        return .noContent
    }
}
