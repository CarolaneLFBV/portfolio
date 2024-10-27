import Fluent
import Vapor

func routes(_ app: Application) throws {
    let database = app.db
    try app.register(collection: UserController(repository: UserRepository(db: database)))
    try app.register(collection: SkillController(repository: SkillRepository(db: database)))
    try app.register(collection: ProjectController(repository: ProjectRepository(db: database)))
    try app.register(collection: ExperienceController(repository: ExperienceRepository(db: database)))
    try app.register(collection: AuthController(repository: AuthRepository(db: database)))
}
