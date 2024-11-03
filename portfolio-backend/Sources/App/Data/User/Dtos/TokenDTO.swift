import Vapor

struct TokenDTO: Content {
    let jwt: String
}
