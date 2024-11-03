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
            let skill = skills.grouped(":skillId")
            skills.get(use: self.index)
            skill.get(use: self.getSkill)

            let protected = skills.grouped([
                User.Middlewares.JWTAuthAuthenticator(),
                User.Middlewares.RoleMiddleware(requiredRole: .admin),
                User.Entity.guardMiddleware()
            ])
            protected.post("create", use: self.create)
            let protectedElement = protected.grouped(":skillId")
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
        return skills.map { SkillOutput(from: $0) }
    }

    // Find a specific skill from repository call
    @Sendable
    func getSkill(req: Request) async throws -> SkillOutput {
        guard let skillId = req.parameters.get("skillId", as: UUID.self),
              let skill = try await repository.find(skillId) else {
            throw Failed.idNotFound
        }
        return SkillOutput(from: skill)
    }

    // Create a new skill from repository call
    @Sendable
    func create(req: Request) async throws -> SkillOutput {
        var skillInput = try req.content.decode(SkillInput.self)
        let skill = skillInput.toModel()
        skillInput.imagePath = nil

        if let image = skillInput.image {
            let imageURL = try await ImageUseCase().upload(image, on: req)
            skillInput.imagePath = imageURL
        }

        try await repository.create(skillInput)
        return SkillOutput(from: skill)
    }

    // Update an existing skill from repository call
    @Sendable
    func update(req: Request) async throws -> SkillOutput {
        guard let skillId = req.parameters.get("skillId", as: UUID.self),
              let skill = try await repository.find(skillId) else {
            throw Failed.idNotFound
        }

        let updatedSkill = try req.content.decode(SkillInput.self)
        skill.name = updatedSkill.name
        skill.tags = updatedSkill.tags
        skill.introduction = updatedSkill.introduction
        skill.history = updatedSkill.history

        if let image = updatedSkill.image {
            let imageData = try await ImageUseCase().upload(image, on: req)
            skill.imageURL = imageData
        }

        try await repository.update(updatedSkill)
        return SkillOutput(from: skill)
    }

    // Delete existing skill from repository call
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let skillId = req.parameters.get("skillId", as: UUID.self),
              let skill = try await repository.find(skillId) else {
            throw Failed.idNotFound
        }

//        if let imageURL = skill.imageURL, !imageURL.isEmpty {
//            try await ImageUseCase().delete(at: imageURL, on: req)
//        }

        try await repository.delete(skill)
        return .noContent
    }

}
