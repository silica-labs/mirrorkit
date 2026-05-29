import Foundation

struct NodeMirror: Identifiable, Equatable {
    let id: String
    let name: String
    let systemImage: String
    let mirrorURL: String?
    let testURL: String
    let isRecommended: Bool

    var isOfficial: Bool { id == "official" }

    static let allPresets: [NodeMirror] = [
        NodeMirror(
            id: "official",
            name: "官方源",
            systemImage: "globe",
            mirrorURL: nil,
            testURL: "https://nodejs.org",
            isRecommended: false
        ),
        NodeMirror(
            id: "aliyun",
            name: "阿里云",
            systemImage: "cloud",
            mirrorURL: "https://mirrors.aliyun.com/nodejs-release/",
            testURL: "https://mirrors.aliyun.com",
            isRecommended: true
        ),
        NodeMirror(
            id: "tencent",
            name: "腾讯云",
            systemImage: "cloud",
            mirrorURL: "https://mirrors.cloud.tencent.com/nodejs-release/",
            testURL: "https://mirrors.cloud.tencent.com",
            isRecommended: false
        ),
        NodeMirror(
            id: "huawei",
            name: "华为云",
            systemImage: "cloud",
            mirrorURL: "https://repo.huaweicloud.com/nodejs/",
            testURL: "https://repo.huaweicloud.com",
            isRecommended: false
        ),
        NodeMirror(
            id: "ustc",
            name: "中国科学技术大学",
            systemImage: "building.columns",
            mirrorURL: "https://mirrors.ustc.edu.cn/node/",
            testURL: "https://mirrors.ustc.edu.cn",
            isRecommended: true
        ),
        NodeMirror(
            id: "tuna",
            name: "清华大学",
            systemImage: "building.columns",
            mirrorURL: "https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/",
            testURL: "https://mirrors.tuna.tsinghua.edu.cn",
            isRecommended: true
        ),
        NodeMirror(
            id: "nju",
            name: "南京大学",
            systemImage: "building.columns",
            mirrorURL: "https://mirror.nju.edu.cn/nodejs-release/",
            testURL: "https://mirror.nju.edu.cn",
            isRecommended: false
        ),
        NodeMirror(
            id: "pku",
            name: "北京大学",
            systemImage: "building.columns",
            mirrorURL: "https://mirrors.pku.edu.cn/nodejs-release/",
            testURL: "https://mirrors.pku.edu.cn",
            isRecommended: false
        ),
        NodeMirror(
            id: "nyist",
            name: "南阳理工学院",
            systemImage: "building.columns",
            mirrorURL: "https://mirror.nyist.edu.cn/nodejs-release/",
            testURL: "https://mirror.nyist.edu.cn",
            isRecommended: false
        ),
        NodeMirror(
            id: "jcut",
            name: "荆楚理工学院",
            systemImage: "building.columns",
            mirrorURL: "https://mirrors.jcut.edu.cn/nodejs-release/",
            testURL: "https://mirrors.jcut.edu.cn",
            isRecommended: false
        )
    ]
}
