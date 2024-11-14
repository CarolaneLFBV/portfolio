import Fluent
import Vapor

extension Project.Controllers {
    struct Config: RouteCollection {
        typealias ProjectRepository = Project.Repositories.ProjectRepository
        typealias ProjectInput = Project.Dto.Input
        typealias ProjectOutput = Project.Dto.Output
        private let repository: ProjectRepository

        init(repository: ProjectRepository) {
            self.repository = repository
        }

        func boot(routes: RoutesBuilder) throws {
            let projects = routes.grouped("projects")
            let project = projects.grouped(":slug")

            projects.get(use: index)
            project.get(use: getProjectBySlug)

            let protected = projects.grouped([
                User.Middlewares.JWTAuthAuthenticator(),
                User.Middlewares.RoleMiddleware(requiredRole: .admin),
                User.Entity.guardMiddleware()
            ])
            protected.post("create", use: create)
            let protectedElement = protected.grouped(":slug")
            protectedElement.patch(use: update)
            protectedElement.delete(use: delete)
        }
    }
}

extension Project.Controllers.Config {
    // Fetch all projects from repository call
    @Sendable
    func index(req: Request) async throws -> [ProjectOutput] {
        let projects = try await repository.findAll()
        return try await projects.toDto(from: req.db)
    }

    // Find a specific project from repository call
    @Sendable
    func getProjectBySlug(req: Request) async throws -> ProjectOutput {
        guard let slug = req.parameters.get("slug"),
              let project = try await repository.find(slug) else {
            throw Failed.idNotFound
        }
        return try await project.toDTO(from: req.db)
    }

    // Create a new project from repository call
    @Sendable
    func create(req: Request) async throws -> HTTPStatus {
        let input = try req.content.decode(ProjectInput.self)
        try await repository.create(input, on: req)
        return .created
    }

    // Update an existing project from repository call
    @Sendable
    func update(req: Request) async throws -> HTTPStatus {
        guard let slug = req.parameters.get("slug") else {
            throw Abort(.notFound)
        }
        let updatedProject = try req.content.decode(ProjectInput.self)
        try await repository.update(updatedProject, slug, on: req)
        return .ok
    }

    // Delete existing project from repository call
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let slug = req.parameters.get("slug") else {
            throw Abort(.notFound)
        }
        try await repository.delete(slug, on: req)
        return .noContent
    }
}
