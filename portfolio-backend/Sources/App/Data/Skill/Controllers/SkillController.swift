import Fluent
import Vapor

struct SkillController: RouteCollection {
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
            JWTAuthAuthenticator(),
            RoleMiddleware(requiredRole: .admin),
            User.guardMiddleware()
        ])
        protected.post("create", use: self.create)
        let protectedElement = protected.grouped(":skillId")
        protectedElement.patch(use: self.update)
        protectedElement.delete(use: self.delete)

    }
}

extension SkillController {
    @Sendable
    func index(req: Request) async throws -> SkillsDTO {
        let skills = try await repository.findAll()
        return skills.map { $0.toDTO() }
    }

    @Sendable
    func getSkill(req: Request) async throws -> SkillDTO {
        guard let skillId = req.parameters.get("skillId", as: UUID.self),
              let skill = try await repository.findById(skillId) else {
            throw Failed.idNotFound
        }
        return skill.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> SkillDTO {
        let skillDTO = try req.content.decode(SkillDTO.self)
        let skill = skillDTO.toModel()

        guard let image = try? req.content.decode(File.self) else {
            throw Failed.invalidData
        }
        
        let imageURL = try await ImageUseCase().upload(image, on: req)
        skill.imageURL = imageURL

        try await repository.create(
            skill,
            projects: skillDTO.projects,
            experiences: skillDTO.experiences
        )
        return skill.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let skillId = req.parameters.get("skillId", as: UUID.self),
                let skill = try await repository.findById(skillId) else {
            throw Failed.idNotFound
        }

        try await repository.delete(skill)
        return .noContent
    }

    @Sendable
    func update(req: Request) async throws -> SkillDTO {
        guard let skillId = req.parameters.get("skillId", as: UUID.self),
              let skill = try await Skill.find(skillId, on: req.db) else {
            throw Failed.idNotFound
        }

        let updatedData = try req.content.decode(SkillDTO.self)
        skill.imageURL = updatedData.imageURL
        skill.name = updatedData.name
        skill.tags = updatedData.tags
        skill.introduction = updatedData.introduction
        skill.history = updatedData.history

        try await repository.update(
            skill,
            projects: updatedData.projects,
            experiences: updatedData.experiences
        )
        return skill.toDTO()
    }
}
