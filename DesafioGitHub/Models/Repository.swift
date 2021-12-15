import Foundation

struct Repository: Decodable, Identifiable {
    let id: Int

    let name: String
    let fullName: String
    let description: String?

    let owner: Owner

    let watchers: Int
    let forks: Int

    let homepage: String?

    let createdAt: Date
    let updatedAt: Date
}
