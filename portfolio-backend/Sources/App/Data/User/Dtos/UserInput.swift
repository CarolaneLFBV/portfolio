import Foundation
import Vapor

extension User.Dto {
    struct Input: Content {
        let image: File?
        var imagePath: String?
        let firstName: String?
        let lastName: String?
        let nickName: String
        let role: UserRole
        let email: String
        let password: String?
        let bio: String?

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: User.Dto.Input.CodingKeys.self)
            let codingKeys = User.Dto.Input.CodingKeys.self
            self.image = try container.decodeIfPresent(File.self,
                                                       forKey: codingKeys.image)
            self.imagePath = try container.decodeIfPresent(String.self,
                                                           forKey: codingKeys.imagePath)
            self.firstName = try container.decodeIfPresent(String.self,
                                                           forKey: codingKeys.firstName)
            self.lastName = try container.decodeIfPresent(String.self,
                                                          forKey: codingKeys.lastName)
            self.nickName = try container.decode(String.self,
                                                 forKey: codingKeys.nickName)
            self.role = try container.decode(UserRole.self,
                                             forKey: codingKeys.role)
            self.email = try container.decode(String.self,
                                              forKey: codingKeys.email)
            self.password = try container.decodeIfPresent(String.self,
                                                          forKey: codingKeys.password)
            self.bio = try container.decodeIfPresent(String.self,
                                                     forKey: codingKeys.bio)
        }

        func toModel() -> User.Entity {
            let user = User.Entity()
            user.firstName = self.firstName ?? ""
            user.lastName = self.lastName ?? ""
            user.nickName = self.nickName
            user.slug = self.nickName.slug()
            user.role = self.role
            user.email = self.email
            user.password = self.password ?? ""
            user.bio = self.bio
            return user
        }
    }
}
