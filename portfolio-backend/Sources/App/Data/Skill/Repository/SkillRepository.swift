import Fluent
import Vapor

protocol SkillProtocol {
    func findAll() async throws -> [Skill]
    func findById(_ id: UUID) async throws -> Skill?
    func create(_ skill: Skill, projects: [UUID], experiences: [UUID]) async throws
    func update(_ skill: Skill, projects: [UUID], experiences: [UUID]) async throws
    func delete(_ skill: Skill) async throws
}

struct SkillRepository: SkillProtocol {
    let db: Database

    func findAll() async throws -> [Skill] {
        try await Skill.query(on: db)
            .with(\.$projects)
            .with(\.$experiences)
            .all()
    }

    func findById(_ id: UUID) async throws -> Skill? {
        try await Skill.query(on: db)
            .filter(\.$id == id)
            .with(\.$projects)
            .with(\.$experiences)
            .first()
    }

    func create(_ skill: Skill, projects: [UUID], experiences: [UUID]) async throws {
        try await skill.save(on: db)

        if !projects.isEmpty {
            let projectModels = try await Project.query(on: db).filter(\.$id ~~ projects).all()
            try await skill.$projects.attach(projectModels, on: db)
        }

        if !experiences.isEmpty {
            let experienceModels = try await Experience.query(on: db).filter(\.$id ~~ experiences).all()
            try await skill.$experiences.attach(experienceModels, on: db)
        }

        try await skill.$projects.load(on: db)
        try await skill.$experiences.load(on: db)
    }

    func update(_ skill: Skill, projects: [UUID], experiences: [UUID]) async throws {
        try await skill.$projects.load(on: db)
        try await skill.$experiences.load(on: db)

        if projects.isEmpty {
            try await skill.$projects.detachAll(on: db)
        } else {
            let projects = try await Project.query(on: db)
                .filter(\.$id ~~ projects)
                .all()
            try await skill.$projects.detachAll(on: db)
            try await skill.$projects.attach(projects, on: db)
        }

        if experiences.isEmpty {
            try await skill.$experiences.detachAll(on: db)
        } else {
            let experiences = try await Experience.query(on: db)
                .filter(\.$id ~~ experiences)
                .all()
            try await skill.$experiences.detachAll(on: db)
            try await skill.$experiences.attach(experiences, on: db)
        }

        try await skill.update(on: db)
    }

    func delete(_ skill: Skill) async throws {
        try await skill.delete(on: db)
    }
}
