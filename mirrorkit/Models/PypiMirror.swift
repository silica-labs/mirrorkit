import Foundation

struct PypiMirror: Identifiable, Equatable {
    let id: String
    let name: String
    let systemImage: String
    let mirrorURL: String?
    let testURL: String
    let isRecommended: Bool
    let trustedHost: String?

    var isOfficial: Bool { mirrorURL == nil }

    static let allPresets: [PypiMirror] = [
        PypiMirror(
            id: "official",
            name: "官方源",
            systemImage: "globe",
            mirrorURL: nil,
            testURL: "https://pypi.org",
            isRecommended: false,
            trustedHost: nil
        ),
        PypiMirror(
            id: "tuna",
            name: "清华大学",
            systemImage: "building.columns",
            mirrorURL: "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple",
            testURL: "https://mirrors.tuna.tsinghua.edu.cn",
            isRecommended: true,
            trustedHost: "mirrors.tuna.tsinghua.edu.cn"
        ),
        PypiMirror(
            id: "bfsu",
            name: "北京外国语大学",
            systemImage: "building.columns",
            mirrorURL: "https://mirrors.bfsu.edu.cn/pypi/web/simple",
            testURL: "https://mirrors.bfsu.edu.cn",
            isRecommended: true,
            trustedHost: "mirrors.bfsu.edu.cn"
        ),
        PypiMirror(
            id: "nju",
            name: "南京大学",
            systemImage: "building.columns",
            mirrorURL: "https://mirror.nju.edu.cn/pypi/web/simple",
            testURL: "https://mirror.nju.edu.cn",
            isRecommended: false,
            trustedHost: "mirror.nju.edu.cn"
        ),
        PypiMirror(
            id: "pku",
            name: "北京大学",
            systemImage: "building.columns",
            mirrorURL: "https://mirrors.pku.edu.cn/pypi/web/simple",
            testURL: "https://mirrors.pku.edu.cn",
            isRecommended: false,
            trustedHost: "mirrors.pku.edu.cn"
        ),
        PypiMirror(
            id: "njtech",
            name: "南京工业大学",
            systemImage: "building.columns",
            mirrorURL: "https://mirrors.njtech.edu.cn/pypi/web/simple",
            testURL: "https://mirrors.njtech.edu.cn",
            isRecommended: false,
            trustedHost: "mirrors.njtech.edu.cn"
        ),
        PypiMirror(
            id: "hust",
            name: "华中科技大学",
            systemImage: "building.columns",
            mirrorURL: "https://mirrors.hust.edu.cn/pypi/web/simple",
            testURL: "https://mirrors.hust.edu.cn",
            isRecommended: false,
            trustedHost: "mirrors.hust.edu.cn"
        ),
        PypiMirror(
            id: "ustc",
            name: "中国科学技术大学",
            systemImage: "building.columns",
            mirrorURL: "https://mirrors.ustc.edu.cn/pypi/web/simple",
            testURL: "https://mirrors.ustc.edu.cn",
            isRecommended: true,
            trustedHost: "mirrors.ustc.edu.cn"
        ),
        PypiMirror(
            id: "sjtu",
            name: "SJTUG 思源",
            systemImage: "building.columns",
            mirrorURL: "https://mirror.sjtu.edu.cn/pypi/web/simple",
            testURL: "https://mirror.sjtu.edu.cn",
            isRecommended: false,
            trustedHost: "mirror.sjtu.edu.cn"
        ),
        PypiMirror(
            id: "sustech",
            name: "南方科技大学",
            systemImage: "building.columns",
            mirrorURL: "https://mirrors.sustech.edu.cn/pypi/web/simple",
            testURL: "https://mirrors.sustech.edu.cn",
            isRecommended: false,
            trustedHost: "mirrors.sustech.edu.cn"
        ),
        PypiMirror(
            id: "zju",
            name: "浙江大学",
            systemImage: "building.columns",
            mirrorURL: "https://mirrors.zju.edu.cn/pypi/web/simple",
            testURL: "https://mirrors.zju.edu.cn",
            isRecommended: false,
            trustedHost: "mirrors.zju.edu.cn"
        ),
        PypiMirror(
            id: "jlu",
            name: "吉林大学",
            systemImage: "building.columns",
            mirrorURL: "https://mirrors.jlu.edu.cn/pypi/web/simple",
            testURL: "https://mirrors.jlu.edu.cn",
            isRecommended: false,
            trustedHost: "mirrors.jlu.edu.cn"
        ),
    ]
}
