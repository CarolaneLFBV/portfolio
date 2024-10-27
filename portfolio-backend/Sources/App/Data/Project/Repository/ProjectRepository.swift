import Vapor
import Fluent

protocol ProjectProtocol {
    func findAll() async throws -> [Project]
    func findById(_ id: UUID) async throws -> Project?
    func create(_ project: Project, skills: [UUID], experiences: [UUID]) async throws
    func update(_ project: Project, skills: [UUID], experiences: [UUID]) async throws
    func delete(_ project: Project) async throws
}

struct ProjectRepository: ProjectProtocol {
    let db: Database

    func findAll() async throws -> [Project] {
        try await Project.query(on: db)
            .with(\.$skills)
            .with(\.$experiences)
            .all()
    }

    func findById(_ id: UUID) async throws -> Project? {
        try await Project.query(on: db)
            .filter(\.$id == id)
            .with(\.$skills)
            .with(\.$experiences)
            .first()
    }

    func create(_ project: Project, skills: [UUID], experiences: [UUID]) async throws {
        try await project.save(on: db)

        if !skills.isEmpty {
            let skillModels = try await Skill.query(on: db).filter(\.$id ~~ skills).all()
            try await project.$skills.attach(skillModels, on: db)
        }

        if !experiences.isEmpty {
            let experienceModels = try await Experience.query(on: db).filter(\.$id ~~ experiences).all()
            try await project.$experiences.attach(experienceModels, on: db)
        }

        try await project.$skills.load(on: db)
        try await project.$experiences.load(on: db)
    }

    func update(_ project: Project, skills: [UUID], experiences: [UUID]) async throws {
        try await project.$skills.load(on: db)
        try await project.$experiences.load(on: db)

        if skills.isEmpty {
            try await project.$skills.detachAll(on: db)
        } else {
            let skills = try await Skill.query(on: db)
                .filter(\.$id ~~ skills)
                .all()
            try await project.$skills.detachAll(on: db)
            try await project.$skills.attach(skills, on: db)
        }

        if experiences.isEmpty {
            try await project.$experiences.detachAll(on: db)
        } else {
            let experiences = try await Experience.query(on: db)
                .filter(\.$id ~~ experiences)
                .all()
            try await project.$experiences.detachAll(on: db)
            try await project.$experiences.attach(experiences, on: db)
        }

        try await project.update(on: db)
    }

    func delete(_ project: Project) async throws {
        try await project.delete(on: db)
    }
}
