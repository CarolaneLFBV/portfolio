import Fluent
import Vapor

struct ProjectController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let projects = routes.grouped("projects")
        let elementRoute = projects.grouped(":projectID")
        projects.get(use: self.index)
        elementRoute.get(use: self.getProject)

        let protected = projects.grouped([JWTAuthenticator()])
        let elementProtectedRoute = protected.grouped(":projectID")
        protected.post(use: self.create)
        elementProtectedRoute.patch(use: self.update)
        elementProtectedRoute.delete(use: self.delete)
    }

    @Sendable
    func index(req: Request) async throws -> [ProjectDTO] {
        try await Project.query(on: req.db).all().map {
            $0.toDTO()
        }
    }

    @Sendable
    func getProject(req: Request) async throws -> ProjectDTO {
        guard let projectID = req.parameters.get("projectID"), let uuid = UUID(projectID) else {
            throw Abort(.notFound)
        }

        guard let project = try await Project.find(uuid, on: req.db) else {
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
        guard let projectID = req.parameters.get("projectID"), let uuid = UUID(projectID) else {
            throw Abort(.badRequest)
        }

        let updatedData = try req.content.decode(ProjectDTO.self)

        guard let project = try await Project.find(uuid, on: req.db) else {
            throw Abort(.notFound)
        }

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
