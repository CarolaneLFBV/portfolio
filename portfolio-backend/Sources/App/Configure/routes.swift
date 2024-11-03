import Fluent
import Vapor

func routes(_ app: Application) throws {
    let database = app.db
    try app.register(
        collection: User.Controllers.Config(
            repository: User.Repositories.UserRepository(
                db: database)
        )
    )
    try app.register(
        collection: Skill.Controllers.Config(
            repository: Skill.Repositories.SkillRepository(
                db: database)
        )
    )
    try app.register(
        collection: Project.Controllers.Config(
            repository: Project.Repositories.ProjectRepository(
                db: database)
        )
    )
    try app.register(
        collection: Experience.Controllers.Config(
            repository: Experience.Repositories.ExperienceRepository(
                db: database)
        )
    )
    try app.register(
        collection: User.Controllers.AuthConfig(
            repository: User.Repositories.AuthRepository(
                db: database)
        )
    )
}
