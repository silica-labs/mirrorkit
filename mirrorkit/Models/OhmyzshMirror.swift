import Foundation

struct OhmyzshMirror: Identifiable, Equatable {
    let id: String
    let name: String
    let systemImage: String
    let gitRemoteURL: String
    let testURL: String
    let isRecommended: Bool

    static let allPresets: [OhmyzshMirror] = [
        OhmyzshMirror(
            id: "official",
            name: "官方源",
            systemImage: "globe",
            gitRemoteURL: "https://github.com/ohmyzsh/ohmyzsh.git",
            testURL: "https://github.com/ohmyzsh/ohmyzsh",
            isRecommended: false
        ),
        OhmyzshMirror(
            id: "tsinghua",
            name: "清华大学",
            systemImage: "building.columns",
            gitRemoteURL: "https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git",
            testURL: "https://mirrors.tuna.tsinghua.edu.cn",
            isRecommended: true
        ),
        OhmyzshMirror(
            id: "nju",
            name: "南京大学",
            systemImage: "building.columns",
            gitRemoteURL: "https://mirrors.nju.edu.cn/git/ohmyzsh.git",
            testURL: "https://mirrors.nju.edu.cn",
            isRecommended: false
        ),
        OhmyzshMirror(
            id: "sjtug",
            name: "上海交大",
            systemImage: "building.columns",
            gitRemoteURL: "https://git.sjtu.edu.cn/sjtug/ohmyzsh.git",
            testURL: "https://git.sjtu.edu.cn/sjtug/ohmyzsh",
            isRecommended: false
        ),
        OhmyzshMirror(
            id: "hust",
            name: "华中科技大学",
            systemImage: "building.columns",
            gitRemoteURL: "https://mirrors.hust.edu.cn/ohmyzsh.git",
            testURL: "https://mirrors.hust.edu.cn",
            isRecommended: false
        ),
        OhmyzshMirror(
            id: "gitee",
            name: "Gitee 码云",
            systemImage: "cloud.fill",
            gitRemoteURL: "https://gitee.com/mirrors/oh-my-zsh.git",
            testURL: "https://gitee.com",
            isRecommended: false
        ),
    ]
}
