import Fluent
import Vapor

struct SkillController: RouteCollection {

    func boot(routes: any RoutesBuilder) throws {
        let skills = routes.grouped("skills")
        let elementRoute = skills.grouped(":skillID")
        skills.get(use: self.index)
        elementRoute.get(use: self.getSkill)

        let protected = skills.grouped([JWTAuthenticator()])
        protected.post("create", use: self.create)
        let elementProtectedRoute = protected.grouped(":skillID")
        elementProtectedRoute.patch(use: self.update)
        elementProtectedRoute.delete(use: self.delete)
    }

    @Sendable
    func index(req: Request) async throws -> [SkillDTO] {
        try await Skill.query(on: req.db).all().map {
            $0.toDTO()
        }
    }

    @Sendable
    func getSkill(req: Request) async throws -> SkillDTO {
        guard let skillID = req.parameters.get("skillID"), let uuid = UUID(skillID) else {
            throw Abort(.notFound)
        }

        guard let skill = try await Skill.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

        return skill.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> SkillDTO {
        let skillDTO = try req.content.decode(SkillDTO.self)
        let skill = Skill(
            name: skillDTO.name,
            tags: skillDTO.tags,
            context: skillDTO.context,
            proofs: skillDTO.proofs,
            retrospective: skillDTO.retrospective,
            progress: skillDTO.progress
        )
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
        guard let skillID = req.parameters.get("skillID"), let uuid = UUID(skillID) else {
            throw Abort(.badRequest)
        }

        let updatedData = try req.content.decode(SkillDTO.self)

        guard let skill = try await Skill.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

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
