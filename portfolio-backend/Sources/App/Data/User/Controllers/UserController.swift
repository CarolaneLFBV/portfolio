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

            let currentProtectedRoute = users.grouped([
                User.Middlewares.JWTAuthAuthenticator(),
                User.Entity.guardMiddleware()
            ])
            currentProtectedRoute.get("current", use: self.getCurrent)

            let protected = users.grouped([
                User.Middlewares.JWTAuthAuthenticator(),
                User.Middlewares.RoleMiddleware(requiredRole: .admin),
                User.Entity.guardMiddleware()
            ])
            let protectedElement = protected.grouped(":slug")
            protectedElement.get(use: self.getUserBySlug)
            protectedElement.on(.PATCH, body: .collect(maxSize: "10mb"), use: self.update)
            protectedElement.delete(use: self.delete)
        }
    }
}

extension User.Controllers.Config {
    @Sendable
    func index(req: Request) async throws -> [UserOutput] {
        let users = try await repository.findAll()
        return try await users.toDto(from: req.db)
    }

    @Sendable
    func getCurrent(req: Request) async throws -> UserOutput {
        guard let user = req.auth.get(User.Entity.self) else {
            throw Failed.accessDenied
        }
        return try user.toDto(from: req.db)
    }

    @Sendable
    func getUserBySlug(req: Request) async throws -> UserOutput {
        guard let slug = req.parameters.get("slug"),
              let user = try await repository.find(slug) else {
            throw Failed.idNotFound
        }
        return try user.toDto(from: req.db)
    }

    @Sendable
    func update(req: Request) async throws -> HTTPStatus {
        guard let slug = req.parameters.get("slug") else {
            throw Failed.idNotFound
        }
        let input = try req.content.decode(UserInput.self)
        try await repository.update(input, slug: slug, on: req)
        return .accepted
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let slug = req.parameters.get("slug") else {
            throw Failed.idNotFound
        }
        try await repository.delete(slug)
        return .noContent
    }
}
