import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        // let user = users.grouped(":userID")
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
        try await User.query(on: req.db).all().map {
            $0.toDTO()
        }
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
        guard let user = try await User.find(req.parameters.get("userId"), on: req.db) else {
            throw Failed.idNotFound
        }

        let updatedData = try req.content.decode(UserDTO.self)

        user.firstName = updatedData.firstName
        user.lastName = updatedData.lastName
        user.email = updatedData.email
        user.role = updatedData.role

        try await user.save(on: req.db)
        return user.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("userId"), on: req.db) else {
            throw Failed.idNotFound
        }

        try await user.delete(on: req.db)
        return .noContent
    }
}
