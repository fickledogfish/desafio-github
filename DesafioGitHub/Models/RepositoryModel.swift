import Foundation

struct RepositoryModel: Decodable, Identifiable {
    let id: Int

    let name: String
    let fullName: String
    let description: String?

    let owner: User

    let watchers: Int
    let forks: Int

    let homepage: String?

    let createdAt: Date
    let updatedAt: Date
}
