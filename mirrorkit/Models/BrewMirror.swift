import Foundation

struct BrewMirror: Identifiable, Equatable, Codable {
    let id: String
    let name: String
    let icon: String
    let brewGitRemote: String?
    let bottleDomain: String?
    let apiDomain: String?

    var isOfficial: Bool { id == "official" }

    var testURL: String {
        if let domain = bottleDomain { return domain }
        return "https://formulae.brew.sh"
    }

    static let allPresets: [BrewMirror] = [
        BrewMirror(
            id: "official",
            name: "官方源",
            icon: "globe",
            brewGitRemote: "https://github.com/Homebrew/brew.git",
            bottleDomain: nil,
            apiDomain: nil
        ),
        BrewMirror(
            id: "tsinghua",
            name: "清华大学",
            icon: "building.columns",
            brewGitRemote: "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git",
            bottleDomain: "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles",
            apiDomain: "https://mirrors.tuna.tsinghua.edu.cn/homebrew/api"
        ),
        BrewMirror(
            id: "ustc",
            name: "中科大",
            icon: "building.columns",
            brewGitRemote: "https://mirrors.ustc.edu.cn/brew.git",
            bottleDomain: "https://mirrors.ustc.edu.cn/homebrew-bottles",
            apiDomain: "https://mirrors.ustc.edu.cn/homebrew/api"
        ),
        BrewMirror(
            id: "aliyun",
            name: "阿里云",
            icon: "cloud",
            brewGitRemote: "https://mirrors.aliyun.com/homebrew/brew.git",
            bottleDomain: "https://mirrors.aliyun.com/homebrew/homebrew-bottles",
            apiDomain: "https://mirrors.aliyun.com/homebrew/api"
        ),
        BrewMirror(
            id: "tencent",
            name: "腾讯云",
            icon: "cloud",
            brewGitRemote: "https://mirrors.cloud.tencent.com/homebrew/brew.git",
            bottleDomain: "https://mirrors.cloud.tencent.com/homebrew-bottles",
            apiDomain: "https://mirrors.cloud.tencent.com/homebrew/api"
        ),
        BrewMirror(
            id: "nju",
            name: "南京大学",
            icon: "building.columns",
            brewGitRemote: "https://mirrors.nju.edu.cn/git/homebrew/brew.git",
            bottleDomain: "https://mirrors.nju.edu.cn/homebrew-bottles",
            apiDomain: "https://mirrors.nju.edu.cn/homebrew/api"
        ),
    ]
}
