import Fluent
import Vapor

extension Experience.Controllers {
    struct Config: RouteCollection {
        typealias ExperienceRepository = Experience.Repositories.ExperienceRepository
        typealias ExperienceInput = Experience.Dto.Input
        typealias ExperienceOutput = Experience.Dto.Output
        private let repository: ExperienceRepository

        init(repository: ExperienceRepository) {
            self.repository = repository
        }

        func boot(routes: any RoutesBuilder) throws {
            let experiences = routes.grouped("experiences")
            let experience = experiences.grouped(":slug")
            experiences.get(use: self.index)
            experience.get(use: self.getExperienceBySlug)

            let protected = experiences.grouped([
                User.Middlewares.JWTAuthAuthenticator(),
                User.Middlewares.RoleMiddleware(requiredRole: .admin),
                User.Entity.guardMiddleware()])
            protected.post("create", use: self.create)

            let protectedElement = protected.grouped(":slug")
            protectedElement.patch(use: self.update)
            protectedElement.delete(use: self.delete)
        }
    }
}

extension Experience.Controllers.Config {
    // Fetch all experiences from repository call
    @Sendable
    func index(req: Request) async throws -> [ExperienceOutput] {
        let experiences = try await repository.findAll()
        return try await experiences.toDto(from: req.db)
    }

    // Find a specific experience from repository call
    @Sendable
    func getExperienceBySlug(req: Request) async throws -> ExperienceOutput {
        guard let slug = req.parameters.get("slug"),
              let experience = try await repository.find(slug) else {
            throw Failed.idNotFound
        }
        return try await experience.toDTO(from: req.db)
    }

    // Create a new experience from repository call
    @Sendable
    func create(req: Request) async throws -> HTTPStatus {
        let input = try req.content.decode(ExperienceInput.self)
        try await repository.create(input, on: req)
        return .created
    }

    // Update an existing project from repository call
    @Sendable
    func update(req: Request) async throws -> HTTPStatus {
        guard let slug = req.parameters.get("slug") else {
            throw Failed.idNotFound
        }
        let input = try req.content.decode(ExperienceInput.self)
        try await repository.update(input, slug, on: req)
        return .ok
    }

    // Delete existing experience from repository call
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let slug = req.parameters.get("slug") else {
            throw Failed.idNotFound
        }
        try await repository.delete(slug, on: req)
        return .noContent
    }

}
