import Fluent
import Vapor

struct ProjectController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let projects = routes.grouped("projects")
        let project = projects.grouped(":projectID")
        projects.get(use: self.index)
        project.get(use: self.getProject)

        let protected = projects.grouped([JWTAuthenticator()])
        protected.post(use: self.create)

        let protectedElement = protected.grouped(":projectID")
        protectedElement.patch(use: self.update)
        protectedElement.delete(use: self.delete)
    }

    @Sendable
    func index(req: Request) async throws -> [ProjectDTO] {
        try await Project.query(on: req.db).all().map {
            $0.toDTO()
        }
    }

    @Sendable
    func getProject(req: Request) async throws -> ProjectDTO {
        guard let project = try await Project.find(req.parameters.get("projectID"), on: req.db) else {
            throw Abort(.notFound)
        }

        return project.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> ProjectDTO {
        let project = try req.content.decode(ProjectDTO.self).toModel()
        try await project.save(on: req.db)
        return project.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let project = try await Project.find(req.parameters.get("projectID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await project.delete(on: req.db)
        return .noContent
    }

    @Sendable
    func update(req: Request) async throws -> ProjectDTO {
        guard let project = try await Project.find(req.parameters.get("expID"), on: req.db) else {
            throw Abort(.notFound)
        }

        let updatedData = try req.content.decode(ProjectDTO.self)

        project.title = updatedData.title
        project.presentation = updatedData.presentation
        project.purpose = updatedData.purpose
        project.milestone = updatedData.milestone
        project.actor = updatedData.actor
        project.progress = updatedData.progress
        project.$skill.id = updatedData.skillID

        return project.toDTO()
    }
}
