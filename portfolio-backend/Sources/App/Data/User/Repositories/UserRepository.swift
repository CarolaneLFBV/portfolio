import Fluent
import Vapor

extension User.Repositories {
    struct UserRepository {
        let db: Database
        typealias UserEntity = User.Entity
        // Fetch all users and return them as UserOutput
        func findAll() async throws -> [UserEntity] {
            try await UserEntity.query(on: db)
                .all()
        }

        // Find a user by ID and return it as UserOutput
        func find(_ slug: String) async throws -> UserEntity? {
            try await UserEntity.query(on: db)
                .filter(\.$slug == slug)
                .first()
        }

        func update(_ input: User.Dto.Input, slug: String, on req: Request) async throws {
            guard let user = try await find(slug) else {
                throw Failed.idNotFound
            }

            user.nickName = input.nickName
            user.slug = input.nickName.slug()
            user.bio = input.bio
            user.role = input.role
            user.email = input.email
            user.introduction = input.introduction
            user.interests = input.interests

            if let image = input.image {
                let imageData = try await ImageUseCase().upload(image, on: req)
                user.imageURL = imageData
            }

            try await user.save(on: db)
        }

        // Delete a user
        func delete(_ slug: String) async throws {
            guard let user = try await find(slug) else {
                throw Failed.idNotFound
            }
            try await user.delete(on: db)
        }
    }

}
