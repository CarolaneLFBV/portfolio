import Fluent
import Vapor

struct UserController: RouteCollection {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: self.index)
        users.get("current", use: self.getAuthenticatedUser)

        let protected = users.grouped([
            JWTAuthAuthenticator(),
             RoleMiddleware(requiredRole: .admin),
             User.guardMiddleware()
        ])
        let protectedElement = protected.grouped(":userId")
        protectedElement.get(use: self.getUser)
        protectedElement.patch(use: self.update)
        protectedElement.delete(use: self.delete)
    }
}

extension UserController {
    @Sendable
    func index(req: Request) async throws -> UsersDTO {
        try await repository.getAllUsers().map { $0.toDTO() }
    }

    @Sendable
    func getAuthenticatedUser(req: Request) async throws -> UserDTO {
        guard let user = req.auth.get(User.self) else {
            throw Failed.accessDenied
        }
        return user.toDTO()
    }

    @Sendable
    func getUser(req: Request) async throws -> UserDTO {
        guard let user = try await User.find(req.parameters.get("userId"), on: req.db) else {
            throw Failed.idNotFound
        }

        return user.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> UserDTO {
        guard let userId = req.parameters.get("userId", as: UUID.self),
              let user = try await repository.findById(userId) else {
            throw Failed.idNotFound
        }

        let updatedData = try req.content.decode(UserDTO.self)
        user.fullName = updatedData.fullName
        user.bio = updatedData.bio
        user.role = updatedData.role
        user.email = updatedData.email
        user.introduction = updatedData.introduction
        user.interests = updatedData.interests

        try await repository.saveUser(user)
        return user.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let userId = req.parameters.get("userId", as: UUID.self),
              let user = try await repository.findById(userId) else {
            throw Failed.idNotFound
        }
        try await repository.deleteUser(user)
        return .noContent
    }
}
