import Fluent
import Vapor

extension User.Repositories {
    struct UserRepository: UserAuthenticable {
        let db: Database
        typealias UserEntity = User.Entity
        // Fetch all users and return them as UserOutput
        func findAll() async throws -> [UserEntity] {
            try await User.Entity.query(on: db)
                .all()
        }

        // Find a user by ID and return it as UserOutput
        func find(_ id: UUID) async throws -> UserEntity? {
            guard let user = try await User.Entity.find(id, on: db) else {
                return nil
            }
            return user
        }

        // Save a new user with UserInput and return as UserOutput
        func saveUser(_ input: User.Dto.Input, on req: Request) async throws {
            let user = input.toModel()

            if let imageFile = input.image {
                let imageURL = try await ImageUseCase().upload(imageFile, on: req)
                user.imageURL = imageURL
            }

            if let password = input.password {
                user.password = try Bcrypt.hash(password)
            }

            try await user.save(on: db)
        }

        // Delete a user
        func deleteUser(_ entity: User.Entity) async throws {
            try await entity.delete(on: db)
        }
    }

}
