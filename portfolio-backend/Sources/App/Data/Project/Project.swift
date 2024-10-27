import Fluent
import Vapor

final class Project: Model, @unchecked Sendable {
    static let schema = "projects"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "imageURL")
    var imageURL: String?

    @Field(key: "name")
    var name: String

    @Field(key: "introduction")
    var introduction: String?

    @Field(key: "presentation")
    var presentation: String?

    @Group(key: "context")
    var context: ContextProject

    @Group(key: "technicalDetails")
    var technicalDetails: TechnicalDetails

    @Siblings(through: ProjectSkill.self, from: \.$project, to: \.$skill)
    var skills: [Skill]

    @Siblings(through: ProjectExperience.self, from: \.$project, to: \.$experience)
    var experiences: [Experience]

    init() {}

    init(id: UUID? = nil,
         imageURL: String?,
         name: String,
         introduction: String?,
         presentation: String?,
         context: ContextProject,
         technicalDetails: TechnicalDetails
    ) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.introduction = introduction
        self.presentation = presentation
        self.context = context
        self.technicalDetails = technicalDetails
    }

    func toDTO() -> ProjectDTO {
        .init(
            id: self.id,
            name: self.name,
            introduction: self.introduction,
            presentation: self.presentation,
            context: self.context,
            technicalDetails: self.technicalDetails,
            skills: self.skills.compactMap({$0.id}),
            experiences: self.experiences.compactMap({$0.id})
        )
    }
}
