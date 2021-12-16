import Foundation

struct PullRequestModel: Decodable, Identifiable {
    let id: Int
    let number: Int

    let createdAt: Date

    let user: User

    let title: String
    let body: String
}
