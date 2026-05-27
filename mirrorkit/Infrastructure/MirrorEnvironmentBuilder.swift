import Foundation

struct MirrorEnvironmentBuilder {
    static func environmentVariables(mirror: MirrorSource) -> [String: String] {
        var vars: [String: String] = [:]
        if let remote = mirror.brewGitRemote {
            vars["HOMEBREW_BREW_GIT_REMOTE"] = remote
        }
        if let bottle = mirror.bottleDomain {
            vars["HOMEBREW_BOTTLE_DOMAIN"] = bottle
        }
        if let api = mirror.apiDomain {
            vars["HOMEBREW_API_DOMAIN"] = api
        }
        return vars
    }
}
