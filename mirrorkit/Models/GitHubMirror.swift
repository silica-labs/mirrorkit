import Foundation

struct GitHubMirror: Identifiable, Equatable {
    let id: String
    let name: String
    let systemImage: String
    let mirrorURL: String?
    let testURL: String

    var isOfficial: Bool { mirrorURL == nil }

    static let allPresets: [GitHubMirror] = [
        GitHubMirror(
            id: "official",
            name: "官方源",
            systemImage: "chevron.left.forwardslash.chevron.right",
            mirrorURL: nil,
            testURL: "https://github.com"
        ),
        GitHubMirror(
            id: "ghfast",
            name: "GhFast",
            systemImage: "hare.fill",
            mirrorURL: "https://ghfast.top/https://github.com/",
            testURL: "https://ghfast.top"
        ),
        GitHubMirror(
            id: "ghproxy",
            name: "GHProxy",
            systemImage: "arrow.forward",
            mirrorURL: "https://ghproxy.com/https://github.com/",
            testURL: "https://ghproxy.com"
        ),
        GitHubMirror(
            id: "gitclone",
            name: "GitClone",
            systemImage: "doc.on.doc",
            mirrorURL: "https://gitclone.com/github.com/",
            testURL: "https://gitclone.com"
        ),
    ]
}
