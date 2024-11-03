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
            let project = projects.grouped(":projectId")

            projects.get(use: index)
            project.get(use: getProject)

            let protected = projects.grouped([
                User.Middlewares.JWTAuthAuthenticator(),
                User.Middlewares.RoleMiddleware(requiredRole: .admin),
                User.Entity.guardMiddleware()
            ])
            protected.post("create", use: create)
            let protectedElement = protected.grouped(":projectId")
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
        return projects.map { ProjectOutput(from: $0) }
    }

    // Find a specific project from repository call
    @Sendable
    func getProject(req: Request) async throws -> ProjectOutput {
        guard let projectId = req.parameters.get("projectId", as: UUID.self),
              let project = try await repository.find(projectId) else {
            throw Abort(.notFound)
        }
        return ProjectOutput(from: project)
    }

    // Create a new project from repository call
    @Sendable
    func create(req: Request) async throws -> ProjectOutput {
        let projectInput = try req.content.decode(ProjectInput.self)
        let project = projectInput.toModel()
        project.imageURLs = []

        if let images = projectInput.images {
            var imagePaths: [String] = []

            for image in images {
                let imagePath = try await ImageUseCase().upload(image, on: req)
                imagePaths.append(imagePath)
            }

            project.imageURLs = imagePaths
        }

        try await repository.create(projectInput)
        return ProjectOutput(from: project)
    }

    // Update an existing project from repository call
    @Sendable
    func update(req: Request) async throws -> ProjectOutput {
        guard let projectId = req.parameters.get("projectId", as: UUID.self),
              let project = try await repository.find(projectId) else {
            throw Abort(.notFound)
        }

        let updatedProject = try req.content.decode(ProjectInput.self)
        project.name = updatedProject.name
        project.introduction = updatedProject.introduction
        project.presentation = updatedProject.presentation
        project.background = updatedProject.background
        project.technicalDetails = updatedProject.technicalDetails

        if let images = updatedProject.images {
            var imagePaths: [String] = []

            for image in images {
                let imagePath = try await ImageUseCase().upload(image, on: req)
                imagePaths.append(imagePath)
            }

            project.imageURLs = imagePaths
        }

        try await repository.update(updatedProject)
        return ProjectOutput(from: project)
    }

    // Delete existing project from repository call
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let projectId = req.parameters.get("projectId", as: UUID.self),
              let project = try await repository.find(projectId) else {
            throw Abort(.notFound)
        }

        try await repository.delete(project)
        return .noContent
    }
}
