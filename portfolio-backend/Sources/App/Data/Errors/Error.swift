import Vapor

struct ErrorDescription: Codable {
    let code: UInt
    let description: String
}

enum Failed: Error {
    case idNotFound
    case accessDenied
    case invalidData
    case bddConnection

    func convert() -> HTTPStatus {
        switch self {
        case .idNotFound:
            return .notFound
        case .accessDenied:
            return .unauthorized
        case .invalidData:
            return .badRequest
        case .bddConnection:
            return .internalServerError
        }
    }
}
