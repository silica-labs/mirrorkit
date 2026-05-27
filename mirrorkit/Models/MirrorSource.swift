import Foundation

struct MirrorSource: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let icon: String
    let brewGitRemote: String?
    let bottleDomain: String?
    let apiDomain: String?

    var isOfficial: Bool { brewGitRemote == nil && bottleDomain == nil }

    var testURL: String {
        if let domain = bottleDomain { return domain }
        return "https://formulae.brew.sh"
    }

    static let allPresets: [MirrorSource] = [
        MirrorSource(
            id: "official",
            name: "官方源",
            icon: "globe",
            brewGitRemote: nil,
            bottleDomain: nil,
            apiDomain: nil
        ),
        MirrorSource(
            id: "tsinghua",
            name: "清华大学 TUNA",
            icon: "graduationcap",
            brewGitRemote: "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git",
            bottleDomain: "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles",
            apiDomain: "https://mirrors.tuna.tsinghua.edu.cn/homebrew/api"
        ),
        MirrorSource(
            id: "ustc",
            name: "中科大 USTC",
            icon: "building.columns",
            brewGitRemote: "https://mirrors.ustc.edu.cn/brew.git",
            bottleDomain: "https://mirrors.ustc.edu.cn/homebrew-bottles",
            apiDomain: "https://mirrors.ustc.edu.cn/homebrew/api"
        ),
        MirrorSource(
            id: "aliyun",
            name: "阿里云",
            icon: "cloud",
            brewGitRemote: "https://mirrors.aliyun.com/homebrew/brew.git",
            bottleDomain: "https://mirrors.aliyun.com/homebrew/homebrew-bottles",
            apiDomain: "https://mirrors.aliyun.com/homebrew/api"
        ),
        MirrorSource(
            id: "tencent",
            name: "腾讯云",
            icon: "cloud.fill",
            brewGitRemote: "https://mirrors.cloud.tencent.com/homebrew/brew.git",
            bottleDomain: "https://mirrors.cloud.tencent.com/homebrew-bottles",
            apiDomain: "https://mirrors.cloud.tencent.com/homebrew/api"
        ),
        MirrorSource(
            id: "nju",
            name: "南京大学",
            icon: "building.columns.fill",
            brewGitRemote: "https://mirrors.nju.edu.cn/git/homebrew/brew.git",
            bottleDomain: "https://mirrors.nju.edu.cn/homebrew-bottles",
            apiDomain: "https://mirrors.nju.edu.cn/homebrew/api"
        ),
    ]
}
