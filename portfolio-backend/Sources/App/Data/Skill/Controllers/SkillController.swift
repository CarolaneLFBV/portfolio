import Fluent
import Vapor

extension Skill.Controllers {
    struct Config: RouteCollection {
        typealias SkillRepository = Skill.Repositories.SkillRepository
        typealias SkillOutput = Skill.Dto.Output
        typealias SkillInput = Skill.Dto.Input
        private let repository: SkillRepository

        init(repository: SkillRepository) {
            self.repository = repository
        }

        func boot(routes: any RoutesBuilder) throws {
            let skills = routes.grouped("skills")
            let skill = skills.grouped(":slug")
            skills.get(use: self.index)
            skill.get(use: self.getSkillbySlug)

            let protected = skills.grouped([
                User.Middlewares.JWTAuthAuthenticator(),
                User.Middlewares.RoleMiddleware(requiredRole: .admin),
                User.Entity.guardMiddleware()
            ])
            protected.post("create", use: self.create)
            let protectedElement = protected.grouped(":slug")
            protectedElement.patch(use: self.update)
            protectedElement.delete(use: self.delete)
        }
    }

}

extension Skill.Controllers.Config {
    // Fetch all skills from repository call
    @Sendable
    func index(req: Request) async throws -> [SkillOutput] {
        let skills = try await repository.findAll()
        return try await skills.toDto(from: req.db)
    }

    // Find a specific skill from repository call
    @Sendable
    func getSkillbySlug(req: Request) async throws -> SkillOutput {
        guard let slug = req.parameters.get("slug"),
              let skill = try await repository.find(slug) else {
            throw Failed.idNotFound
        }
        return try await skill.toDTO(from: req.db)
    }

    // Create a new skill from repository call
    @Sendable
    func create(req: Request) async throws -> HTTPStatus {
        var skillInput = try req.content.decode(SkillInput.self)
        skillInput.imagePath = nil
        try await repository.create(skillInput, on: req)
        return .created
    }

    // Update an existing skill from repository call
    @Sendable
    func update(req: Request) async throws -> HTTPStatus {
        guard let slug = req.parameters.get("slug") else {
            throw Failed.idNotFound
        }
        let updatedSkill = try req.content.decode(SkillInput.self)
        try await repository.update(updatedSkill, slug, on: req)
        return .ok
    }

    // Delete existing skill from repository call
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let slug = req.parameters.get("slug") else {
            throw Failed.idNotFound
        }
        try await repository.delete(slug, req: req)
        return .noContent
    }
}
