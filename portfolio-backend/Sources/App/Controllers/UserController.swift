import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: self.index)

        let protected = users.grouped([JWTAuthenticator()])
        protected.get("current", use: self.getAuthenticatedUser)

        let elementProtectedRoute = protected.grouped(":userID")
        elementProtectedRoute.get(use: self.getUserById)
        elementProtectedRoute.patch(use: self.update)

    }

    @Sendable
    func index(req: Request) async throws -> [UserDTO] {
        try await User.query(on: req.db).all().map {
            $0.toDTO()
        }
    }

    @Sendable
    func getAuthenticatedUser(req: Request) async throws -> UserDTO {
        guard let user = req.auth.get(User.self) else {
            throw Abort(.unauthorized, reason: "User is not authenticated")
        }
        return user.toDTO()
    }

    @Sendable
    func getUserById(req: Request) async throws -> UserDTO {
        guard let userID = req.parameters.get("userID"), let uuid = UUID(userID) else {
            throw Abort(.badRequest)
        }

        guard let user = try await User.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

        return user.toDTO()
    }

    @Sendable
    func update(req: Request) async throws -> UserDTO {
        guard let userID = req.parameters.get("userID"), let uuid = UUID(userID) else {
            throw Abort(.badRequest)
        }

        let updatedData = try req.content.decode(UserDTO.self)

        guard let user = try await User.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

        user.firstName = updatedData.firstName
        user.lastName = updatedData.lastName
        user.email = updatedData.email
        user.role = updatedData.role

        try await user.save(on: req.db)

        return user.toDTO()
    }
}
