import Fluent
import Vapor

struct SkillController: RouteCollection {

    func boot(routes: any RoutesBuilder) throws {
        let skills = routes.grouped("skills")
        let skill = skills.grouped(":skillID")
        skills.get(use: self.index)
        skill.get(use: self.getSkill)

        // JWT protection on skills
        let protected = skills.grouped([JWTAuthenticator()])
        protected.post("create", use: self.create)

        // JWT protection on one skill
        let protectedElement = protected.grouped(":skillID")
        protectedElement.patch(use: self.update)
        protectedElement.delete(use: self.delete)

        // TODO: - Add Admin Middleware for create/update/delete
    }

    @Sendable
    func index(req: Request) async throws -> [SkillDTO] {
        try await Skill.query(on: req.db).all().map {
            $0.toDTO()
        }
    }

    @Sendable
    func getSkill(req: Request) async throws -> SkillDTO {
        guard let skill = try await Skill.find(req.parameters.get("skillID"), on: req.db) else {
            throw Abort(.notFound)
        }

        return skill.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> SkillDTO {
        let skill = try req.content.decode(SkillDTO.self).toModel()
        try await skill.save(on: req.db)
        return skill.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let skill = try await Skill.find(req.parameters.get("skillID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await skill.delete(on: req.db)
        return .noContent
    }

    @Sendable
    func update(req: Request) async throws -> SkillDTO {
        guard let skill = try await Skill.find(req.parameters.get("skillID"), on: req.db) else {
            throw Abort(.notFound)
        }

        let updatedData = try req.content.decode(SkillDTO.self)

        skill.name = updatedData.name
        skill.tags = updatedData.tags
        skill.context = updatedData.context
        skill.proofs = updatedData.proofs
        skill.retrospective = updatedData.retrospective
        skill.progress = updatedData.progress

        try await skill.save(on: req.db)
        return skill.toDTO()
    }
}
