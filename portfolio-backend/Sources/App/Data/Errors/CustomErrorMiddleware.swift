import Vapor

struct CustomErrorMiddleware: AsyncMiddleware {
    func respond(to request: Vapor.Request, chainingTo next: any Vapor.AsyncResponder) async throws -> Vapor.Response {
        do {
            return try await next.respond(to: request)
        } catch let error as Failed {
            let customError = error.convert()
            let code = customError.code
            let description = customError.description + " (throw: \(error))"

            do {
                let errorDescription = ErrorDescription(code: code,
                                                        description: description)
                let body = try Response.Body(data: JSONEncoder().encode(errorDescription))
                return Response(status: customError, body: body)
            } catch {
                return Response(status: .internalServerError, body: .init(string: "Error encoding response"))
            }
        } catch {
            return try await next.respond(to: request)
        }
    }
}
