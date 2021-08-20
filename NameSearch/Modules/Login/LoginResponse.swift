
struct LoginResponse: Decodable {
    let auth: Auth
    let user: User
}

struct User: Decodable {
    let first: String
    let last: String
}

struct Auth: Decodable {
    let token: String
}
